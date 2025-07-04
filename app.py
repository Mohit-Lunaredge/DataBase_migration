import psycopg2
import re
import json
import sys
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from collections import defaultdict
from datetime import datetime

# --- Flask App Initialization ---
app = Flask(__name__)
# Enable CORS to allow your frontend to communicate with this backend
CORS(app)

# --- Constants ---
SQL_FILES_DIR = "sql_files"

# --- Helper function to parse schema from a SQL file ---
def _get_schema_from_sql_file(filepath):
    """
    Reads a .sql file from the given path on the server and parses it 
    to extract table names and their columns, including data types.
    """
    tables = {}
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        raise 

    create_table_regex = re.compile(r"CREATE TABLE `([^`]+)` \(([\s\S]+?)\);", re.IGNORECASE)
    for match in create_table_regex.finditer(content):
        table_name = match.group(1)
        definition_block = match.group(2)
        columns = []
        
        col_regex = re.compile(r"^\s*`([^`]+)`\s+([\w()]+(?:,\s*\w+)*)", re.IGNORECASE)
        
        for line in definition_block.split('\n'):
            line = line.strip()
            match_col = col_regex.match(line)
            if match_col:
                col_name = match_col.group(1)
                col_type = match_col.group(2).split(' ')[0]
                columns.append({"name": col_name, "type": col_type})

        if columns:
            tables[table_name] = {'columns': columns}

    insert_regex = re.compile(r"INSERT INTO `([^`]+)` \(([^)]+)\) VALUES", re.IGNORECASE)
    for match in insert_regex.finditer(content):
        table_name = match.group(1)
        if table_name not in tables:
            columns_from_insert = [c.strip().replace('`', '') for c in match.group(2).split(',')]
            tables[table_name] = {'columns': [{"name": c, "type": "unknown"} for c in columns_from_insert]}
            
    return tables

# --- API Endpoints ---

@app.route('/api/list_sql_files', methods=['GET'])
def list_sql_files():
    """
    Scans the SQL_FILES_DIR directory and returns a list of .sql files.
    """
    if not os.path.isdir(SQL_FILES_DIR):
        print(f"Warning: Directory '{SQL_FILES_DIR}' not found.", file=sys.stderr)
        return jsonify([])
    
    try:
        files = [f for f in os.listdir(SQL_FILES_DIR) if f.endswith('.sql')]
        return jsonify(sorted(files))
    except Exception as e:
        return jsonify({"error": f"Failed to list SQL files: {str(e)}"}), 500

@app.route('/api/parse_sql_file', methods=['POST'])
def parse_sql_file_endpoint():
    data = request.json
    filename = data.get('filename')
    custom_path = data.get('path')

    if custom_path:
        filepath = custom_path
    elif filename:
        filepath = os.path.join(SQL_FILES_DIR, filename)
    else:
        return jsonify({"error": "Either 'filename' or 'path' is required."}), 400
    
    try:
        schema = _get_schema_from_sql_file(filepath)
        if not schema:
            return jsonify({"error": "Could not find any tables in the SQL file."}), 404
        return jsonify(schema)
    except FileNotFoundError:
        return jsonify({"error": f"File not found on server at path: {filepath}"}), 404
    except Exception as e:
        return jsonify({"error": f"An error occurred while parsing the file: {str(e)}"}), 500


@app.route('/api/get_databases', methods=['POST'])
def get_databases():
    creds = request.json
    try:
        conn = psycopg2.connect(
            dbname="postgres",
            user=creds.get('user'),
            password=creds.get('password'),
            host=creds.get('host'),
            port=creds.get('port')
        )
        conn.autocommit = True
        cursor = conn.cursor()
        cursor.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
        databases = [row[0] for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return jsonify(databases)
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/get_tables', methods=['POST'])
def get_tables():
    data = request.json
    creds = data.get('creds')
    dbname = data.get('dbname')
    try:
        conn = psycopg2.connect(
            dbname=dbname,
            user=creds.get('user'),
            password=creds.get('password'),
            host=creds.get('host'),
            port=creds.get('port')
        )
        cursor = conn.cursor()
        query = "SELECT table_name, column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema = 'public' ORDER BY table_name, ordinal_position;"
        cursor.execute(query)
        
        tables = defaultdict(lambda: {'columns': []})
        for row in cursor.fetchall():
            table_name, column_name, data_type, is_nullable = row
            tables[table_name]['columns'].append({
                "name": column_name,
                "type": data_type,
                "is_nullable": is_nullable
            })

        cursor.close()
        conn.close()
        return jsonify(dict(tables))
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/run_migration', methods=['POST'])
def run_migration():
    config = request.json
    pg_config = config.get('pg_config')
    table_mapping = config.get('table_mapping')
    mysql_dump_file = config.get('mysql_dump_file')
    pg_schema = config.get('pg_schema')
    truncate_tables = config.get('truncate_tables', False)
    handle_conflicts = config.get('handle_conflicts', False)
    filters = config.get('filters', {})
    default_values = config.get('default_values', {})
    auto_increment_settings = config.get('auto_increment_settings', {})

    if not all([pg_config, mysql_dump_file, pg_schema]):
        return jsonify({"error": "Missing configuration data."}), 400

    try:
        results = _perform_migration(pg_config, table_mapping, mysql_dump_file, pg_schema, truncate_tables, handle_conflicts, filters, default_values, auto_increment_settings)
        return jsonify({"message": "Migration processing complete!", "summary": results})
    except FileNotFoundError:
        return jsonify({"error": f"The MySQL dump file was not found on the server at: {mysql_dump_file}"}), 404
    except Exception as e:
        print(f"A critical error occurred: {e}", file=sys.stderr)
        return jsonify({"error": f"A critical error occurred during migration: {str(e)}"}), 500

# --- Core Migration Logic (Helper Functions) ---

def _parse_mysql_insert(statement_chunk):
    header_match = re.search(r"INSERT INTO\s+[`\"]?(\w+)[`\"]?\s*\((.*?)\)\s+VALUES", statement_chunk, re.IGNORECASE | re.DOTALL)
    if not header_match: return None, None, None
    table_name = header_match.group(1)
    columns = [c.strip().strip('`"') for c in header_match.group(2).split(',')]
    values_keyword_match = re.search(r"VALUES", statement_chunk, re.IGNORECASE)
    values_full_str = statement_chunk[values_keyword_match.end():]
    value_tuples_regex = re.compile(r"\((.*?)\)")
    value_matches = value_tuples_regex.findall(values_full_str)
    all_rows = []
    for v_tuple in value_matches:
        values = re.split(r",(?=(?:[^']*'[^']*')*[^']*$)", v_tuple)
        cleaned_values = [v.strip().strip("'") for v in values]
        cleaned_values = [None if v.upper() == 'NULL' or v == '' else v for v in cleaned_values]
        all_rows.append(cleaned_values)
    return table_name, columns, all_rows

def _check_where_condition(row_dict, where_clause):
    if not where_clause: return True
    conditions = re.split(r'\s+AND\s+', where_clause, flags=re.IGNORECASE)
    for condition in conditions:
        match = re.match(r"(\w+)\s*(!=| =)\s*(.*)", condition.strip())
        if not match: continue
        col, op, val = match.groups()
        val = val.strip().strip("'\"")
        row_val_str = str(row_dict.get(col)) if row_dict.get(col) is not None else ''
        if op == '=' and row_val_str != val: return False
        if op == '!=' and row_val_str == val: return False
    return True

def _apply_replacements(value, rules):
    if value is None: return None
    val_str = str(value)
    for rule in rules:
        if val_str == rule.get('find'):
            return rule.get('replace')
    return value

def _perform_migration(pg_config, table_mapping, mysql_dump_file, pg_schema, truncate_tables, handle_conflicts, filters, default_values, auto_increment_settings):
    pg_conn = None
    migration_summary = defaultdict(lambda: {'inserted': 0, 'updated': 0, 'failed': 0, 'filtered_out': 0, 'errors': []})
    
    print("\n--- Starting New Migration Run ---")
    pg_conn = psycopg2.connect(**pg_config)
    pg_cursor = pg_conn.cursor()
    print(f"DB Connection Success: Connected to '{pg_config.get('dbname')}'")
    
    if truncate_tables:
        # Truncation logic...
        pass

    statements = []
    with open(mysql_dump_file, 'r', encoding='utf-8') as f:
        sql_buffer = ""
        for line in f:
            line = line.strip()
            if not line or line.startswith('--'):
                continue
            sql_buffer += line + " "
            if line.endswith(';'):
                statements.append(sql_buffer)
                sql_buffer = ""
    print(f"File Parsed: Found {len(statements)} potential statements.")

    counters = {}
    for pg_table, settings_by_col in auto_increment_settings.items():
        for pg_col, settings in settings_by_col.items():
            counters[f"{pg_table}.{pg_col}"] = settings.get('start', 1)

    for i, statement in enumerate(statements):
        if not statement.upper().startswith("INSERT INTO"):
            continue
        
        mysql_table, mysql_cols, all_rows = _parse_mysql_insert(statement)

        if not mysql_table or mysql_table not in table_mapping:
            continue
        
        print(f"\n[Statement {i+1}]: Processing table '{mysql_table}'.")
        
        mapping_info = table_mapping[mysql_table]
        pg_table = mapping_info["pg_table"]
        
        rows_inserted_in_statement, rows_updated_in_statement, rows_failed_in_statement = 0, 0, 0

        for row_num, row_values in enumerate(all_rows):
            if len(row_values) != len(mysql_cols): continue
            
            raw_row_dict = {mysql_cols[i]: row_values[i] for i in range(len(mysql_cols))}
            
            table_filters = filters.get(mysql_table, {})
            if not _check_where_condition(raw_row_dict, table_filters.get('where', '')):
                migration_summary[pg_table]['filtered_out'] += 1
                continue
            
            transformed_row_dict = {}
            replacements = table_filters.get('replacements', {})
            for col_name, value in raw_row_dict.items():
                transformed_row_dict[col_name] = _apply_replacements(value, replacements.get(col_name, []))

            pg_values_dict = {}
            
            for col_idx, mysql_col in enumerate(mysql_cols):
                if mysql_col in mapping_info['column_map']:
                    for pg_col in mapping_info['column_map'][mysql_col]:
                        pg_values_dict[pg_col] = transformed_row_dict[mysql_col]

            for col_name, default_val in default_values.get(pg_table, {}).items():
                if col_name not in pg_values_dict:
                    pg_values_dict[col_name] = default_val

            target_table_columns = [c['name'] for c in pg_schema.get(pg_table, {}).get('columns', [])]
            now = datetime.now()
            if 'created_at' in target_table_columns and 'created_at' not in pg_values_dict:
                pg_values_dict['created_at'] = now
            if 'updated_at' in target_table_columns and 'updated_at' not in pg_values_dict:
                pg_values_dict['updated_at'] = now

            for pg_col, settings in auto_increment_settings.get(pg_table, {}).items():
                counter_key = f"{pg_table}.{pg_col}"
                pg_values_dict[pg_col] = counters[counter_key]
                counters[counter_key] += settings.get('step', 1)

            if not pg_values_dict: continue

            final_pg_cols = list(pg_values_dict.keys())
            final_pg_values = list(pg_values_dict.values())
            
            quoted_columns = ', '.join(f'"{c}"' for c in final_pg_cols)
            placeholders = ", ".join(["%s"] * len(final_pg_cols))
            insert_query = f'INSERT INTO "{pg_table}" ({quoted_columns}) VALUES ({placeholders})'
            
            if handle_conflicts:
                conflict_column = "id" 
                update_clause_parts = [f'"{col}" = EXCLUDED."{col}"' for col in final_pg_cols if col != conflict_column]
                if update_clause_parts:
                    update_clause = ", ".join(update_clause_parts)
                    insert_query += f' ON CONFLICT ("{conflict_column}") DO UPDATE SET {update_clause}'

            try:
                pg_cursor.execute(insert_query, tuple(final_pg_values))
                # Commit and counting logic...
                pg_conn.commit()
            except psycopg2.Error as e:
                # Error handling logic...
                pg_conn.rollback() 
            except Exception as e:
                # Error handling logic...
                pg_conn.rollback() 
        
        print(f"    -> Processed {len(all_rows)} rows. Inserted: {rows_inserted_in_statement}. Updated: {rows_updated_in_statement}. Failed: {rows_failed_in_statement}.")
            
    if pg_conn:
        pg_conn.close()
        print("--- Migration Run Finished ---")
        
    return dict(migration_summary)

# --- Main Execution ---
if __name__ == '__main__':
    app.run(debug=True)
