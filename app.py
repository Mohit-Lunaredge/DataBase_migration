import psycopg2
import re
import json
import sys
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from collections import defaultdict, deque
from datetime import datetime

# --- Flask App Initialization ---
app = Flask(__name__)
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
        columns = []
        col_regex = re.compile(r"^\s*`([^`]+)`\s+([\w()]+)", re.IGNORECASE)
        for line in match.group(2).split('\n'):
            match_col = col_regex.match(line.strip())
            if match_col:
                columns.append({"name": match_col.group(1), "type": match_col.group(2)})
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
    if not os.path.isdir(SQL_FILES_DIR):
        if not os.path.exists(SQL_FILES_DIR):
            os.makedirs(SQL_FILES_DIR)
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
    filepath = custom_path if custom_path else os.path.join(SQL_FILES_DIR, filename)
    if not filepath: return jsonify({"error": "File path is required."}), 400
    try:
        schema = _get_schema_from_sql_file(filepath)
        return jsonify(schema)
    except FileNotFoundError:
        return jsonify({"error": f"File not found on server at path: {filepath}"}), 404
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/api/get_databases', methods=['POST'])
def get_databases():
    creds = request.json
    try:
        conn = psycopg2.connect(dbname="postgres", user=creds.get('user'), password=creds.get('password'), host=creds.get('host'), port=creds.get('port'))
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
        conn = psycopg2.connect(dbname=dbname, user=creds.get('user'), password=creds.get('password'), host=creds.get('host'), port=creds.get('port'))
        cursor = conn.cursor()
        query = "SELECT table_name, column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema = 'public' ORDER BY table_name, ordinal_position;"
        cursor.execute(query)
        tables = defaultdict(lambda: {'columns': []})
        for row in cursor.fetchall():
            table_name, column_name, data_type, is_nullable = row
            tables[table_name]['columns'].append({"name": column_name, "type": data_type, "is_nullable": is_nullable})
        cursor.close()
        conn.close()
        return jsonify(dict(tables))
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/run_migration', methods=['POST'])
def run_migration():
    config = request.json
    
    # --- FIX STARTS HERE ---
    # The client sends a 'mysql_dump_file_path' which could be a full path
    # or just a filename from the dropdown. We need to construct the correct
    # path to the file on the server before proceeding.
    file_path_from_client = config.get('mysql_dump_file_path')
    
    # Check if the path from the client is an absolute path.
    # If not, assume it's a filename that should be in our SQL_FILES_DIR.
    if not os.path.isabs(file_path_from_client):
        # It's a relative path or simple filename, so construct the full path.
        full_file_path = os.path.join(SQL_FILES_DIR, file_path_from_client)
    else:
        # The client provided a full/absolute path. Use it as is.
        full_file_path = file_path_from_client

    # Update the config with the correct, full path before passing it to the migration logic.
    config['mysql_dump_file_path'] = full_file_path
    # --- FIX ENDS HERE ---

    try:
        results = _perform_migration(config)
        return jsonify({"message": "Migration processing complete!", "summary": results})
    except FileNotFoundError:
        # Now this error message will show the full, correct path we tried to open.
        return jsonify({"error": f"The MySQL dump file was not found on the server at path: {config.get('mysql_dump_file_path')}"}), 404
    except Exception as e:
        print(f"A critical error occurred: {e}", file=sys.stderr)
        return jsonify({"error": f"A critical error occurred during migration: {str(e)}"}), 500

# --- Core Migration Logic ---

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
        cleaned_values = [None if v.strip().strip("'").upper() == 'NULL' or v.strip() == "''" else v.strip().strip("'") for v in values]
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

def _apply_transformation(row_dict, rule):
    if rule['function'] == 'CONCAT':
        params = rule['params']
        columns_to_concat = params.get('columns', [])
        separator = params.get('separator', '')
        
        values_to_concat = []
        for col_name in columns_to_concat:
            val = row_dict.get(col_name)
            if val is not None:
                values_to_concat.append(str(val))
        
        return separator.join(values_to_concat)
    # Future transformations can be added here with elif
    return None

def _topological_sort(nodes, dependencies):
    in_degree = {node: 0 for node in nodes}
    adj = {node: [] for node in nodes}
    
    for node, deps in dependencies.items():
        for dep in deps:
            if node in adj.get(dep, []): continue
            adj[dep].append(node)
            in_degree[node] += 1
            
    queue = deque([node for node in nodes if in_degree[node] == 0])
    sorted_order = []
    while queue:
        u = queue.popleft()
        sorted_order.append(u)
        for v in adj.get(u, []):
            in_degree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)

    if len(sorted_order) == len(nodes):
        return sorted_order
    else:
        raise Exception("Circular dependency detected in table lookups.")

def _perform_migration(config):
    pg_conn = psycopg2.connect(**config['pg_config'])
    pg_cursor = pg_conn.cursor()
    migration_summary = defaultdict(lambda: defaultdict(lambda: 0, {'errors': []}))
    
    mapping_rules = config.get('mapping_rules', {})
    filters = config.get('filters', {})
    
    with open(config['mysql_dump_file_path'], 'r', encoding='utf-8') as f:
        full_content = f.read()
    
    all_data = defaultdict(list)
    insert_statement_regex = re.compile(r"INSERT INTO .*?;\n", re.IGNORECASE | re.DOTALL)
    for statement_match in insert_statement_regex.finditer(full_content):
        mysql_table, mysql_cols, all_rows = _parse_mysql_insert(statement_match.group(0))
        if mysql_table:
            for row in all_rows:
                all_data[mysql_table].append(dict(zip(mysql_cols, row)))

    dependencies = defaultdict(set)
    all_source_tables = set()
    mapped_pg_tables = set()
    for pg_table, cols in mapping_rules.items():
        mapped_pg_tables.add(pg_table)
        for pg_col, rule in cols.items():
            source_table = rule.get('source_table')
            if source_table:
                all_source_tables.add(source_table)
                if rule['type'] == 'lookup':
                    lookup_source_table = rule.get('lookup_source_table')
                    if lookup_source_table:
                        dependencies[source_table].add(lookup_source_table)

    order = _topological_sort(list(all_source_tables), dependencies)
    print(f"Determined migration order: {order}")

    if config.get('truncate_tables'):
        for pg_table in reversed(order):
                 if pg_table in mapped_pg_tables:
                    pg_cursor.execute(f'TRUNCATE TABLE "{pg_table}" RESTART IDENTITY CASCADE;')
        pg_conn.commit()
        print("Target tables truncated.")

    counters = {}
    for pg_table, cols in mapping_rules.items():
        for pg_col, rule in cols.items():
            if rule['type'] == 'auto-increment':
                counters[f"{pg_table}.{pg_col}"] = rule.get('start', 1)

    for mysql_table in order:
        if not all_data[mysql_table]: continue
        print(f"\nProcessing source table: {mysql_table}")
        
        pg_table = next((pg_tbl for pg_tbl, rules in mapping_rules.items() if any(r.get('source_table') == mysql_table for r in rules.values())), None)
        if not pg_table: continue
        
        for row_dict in all_data[mysql_table]:
            table_filters = filters.get(mysql_table, {})
            if not _check_where_condition(row_dict, table_filters.get('where', '')):
                migration_summary[pg_table]['filtered_out'] += 1
                continue
            
            transformed_row_dict = {}
            replacements = table_filters.get('replacements', {})
            for col_name, value in row_dict.items():
                transformed_row_dict[col_name] = _apply_replacements(value, replacements.get(col_name, []))
            
            pg_values_dict = {}
            
            for pg_col, rule in mapping_rules.get(pg_table, {}).items():
                if rule.get('source_table') != mysql_table and rule['type'] not in ['static', 'auto-increment', 'lookup', 'transformation']:
                    continue

                if rule['type'] == 'direct':
                    pg_values_dict[pg_col] = transformed_row_dict.get(rule['value'])
                elif rule['type'] == 'static':
                    pg_values_dict[pg_col] = rule['value']
                elif rule['type'] == 'auto-increment':
                    counter_key = f"{pg_table}.{pg_col}"
                    pg_values_dict[pg_col] = counters.get(counter_key, 1)
                    counters[counter_key] = counters.get(counter_key, 1) + rule.get('step', 1)
                elif rule['type'] == 'transformation':
                    pg_values_dict[pg_col] = _apply_transformation(transformed_row_dict, rule)
                elif rule['type'] == 'lookup':
                    match_value = transformed_row_dict.get(rule['match_col'])
                    lookup_query = f'SELECT "{rule["get_col"]}" FROM "{rule["lookup_table"]}" WHERE "{rule["where_col"]}" = %s'
                    pg_cursor.execute(lookup_query, (match_value,))
                    result = pg_cursor.fetchone()
                    pg_values_dict[pg_col] = result[0] if result else None
            
            if not pg_values_dict: continue

            final_pg_cols = list(pg_values_dict.keys())
            final_pg_values = list(pg_values_dict.values())
            
            quoted_columns = ', '.join(f'"{c}"' for c in final_pg_cols)
            placeholders = ", ".join(["%s"] * len(final_pg_cols))
            insert_query = f'INSERT INTO "{pg_table}" ({quoted_columns}) VALUES ({placeholders})'
            
            if config.get('handle_conflicts'):
                conflict_column = "id" 
                update_clause_parts = [f'"{col}" = EXCLUDED."{col}"' for col in final_pg_cols if col != conflict_column]
                if update_clause_parts:
                    update_clause = ", ".join(update_clause_parts)
                    insert_query += f' ON CONFLICT ("{conflict_column}") DO UPDATE SET {update_clause}'

            try:
                pg_cursor.execute(insert_query, tuple(final_pg_values))
                if config.get('handle_conflicts') and "UPDATE" in pg_cursor.statusmessage:
                    migration_summary[pg_table]['updated'] += 1
                elif pg_cursor.rowcount > 0:
                    migration_summary[pg_table]['inserted'] += 1
                pg_conn.commit()
            except psycopg2.Error as e:
                pg_conn.rollback() 
                migration_summary[pg_table]['failed'] += 1
                if len(migration_summary[pg_table]['errors']) < 5:
                    error_detail = { "error": f"PostgreSQL Error: {e.pgerror or str(e).strip()}", "pgcode": e.pgcode, "query": insert_query, "values": [str(v) for v in final_pg_values] }
                    migration_summary[pg_table]['errors'].append(error_detail)
            except Exception as e:
                pg_conn.rollback() 
                migration_summary[pg_table]['failed'] += 1
                if len(migration_summary[pg_table]['errors']) < 5:
                    error_detail = { "error": f"Generic Error: {str(e).strip()}", "pgcode": "N/A", "query": insert_query, "values": [str(v) for v in final_pg_values] }
                    migration_summary[pg_table]['errors'].append(error_detail)
            
    pg_conn.close()
    return dict(migration_summary)

if __name__ == '__main__':
    app.run(debug=True)
