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

    # Regex to find CREATE TABLE statements and capture table name and columns block
    create_table_regex = re.compile(r"CREATE TABLE `([^`]+)` \(([\s\S]+?)\);", re.IGNORECASE)
    for match in create_table_regex.finditer(content):
        table_name = match.group(1)
        columns = []
        # Regex to find column name and type within the columns block
        col_regex = re.compile(r"^\s*`([^`]+)`\s+([\w()]+)", re.IGNORECASE)
        for line in match.group(2).split('\n'):
            match_col = col_regex.match(line.strip())
            if match_col:
                columns.append({"name": match_col.group(1), "type": match_col.group(2)})
        if columns:
            tables[table_name] = {'columns': columns}

    # Regex to find INSERT INTO statements to infer schema if CREATE TABLE is missing
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
    """Lists all .sql files in the predefined SQL_FILES_DIR."""
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
    """Parses a given SQL file from the server and returns its schema."""
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
    """Connects to PostgreSQL and fetches a list of all non-template databases."""
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
    """Fetches the schema (tables and columns) for a specific PostgreSQL database."""
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
    """The main endpoint to trigger the data migration process based on user configuration."""
    config = request.json
    file_path_from_client = config.get('mysql_dump_file_path')
    if not os.path.isabs(file_path_from_client):
        full_file_path = os.path.join(SQL_FILES_DIR, file_path_from_client)
    else:
        full_file_path = file_path_from_client
    config['mysql_dump_file_path'] = full_file_path
    try:
        results = _perform_migration(config)
        return jsonify({"message": "Migration processing complete!", "summary": results})
    except FileNotFoundError:
        return jsonify({"error": f"The MySQL dump file was not found on the server at path: {config.get('mysql_dump_file_path')}"}), 404
    except Exception as e:
        print(f"A critical error occurred: {e}", file=sys.stderr)
        return jsonify({"error": f"A critical error occurred during migration: {str(e)}"}), 500

@app.route('/api/get_column_data', methods=['POST'])
def get_column_data():
    """
    Parses a specific table from a MySQL dump file to extract all unique values 
    from a given column. This is used for data preview in the UI.
    """
    data = request.json
    filename = data.get('filename')
    custom_path = data.get('path')
    table_name_to_find = data.get('tableName')
    column_name_to_find = data.get('columnName')

    if not (filename or custom_path) or not table_name_to_find or not column_name_to_find:
        return jsonify({"error": "File path, table name, and column name are required."}), 400

    filepath = custom_path if custom_path else os.path.join(SQL_FILES_DIR, filename)

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            full_content = f.read()
    except FileNotFoundError:
        return jsonify({"error": f"File not found on server at path: {filepath}"}), 404
    except Exception as e:
        return jsonify({"error": f"An error occurred while reading the file: {str(e)}"}), 500

    unique_values = set()
    total_rows = 0
    insert_statement_regex = re.compile(
        r"INSERT INTO\s+[`\"]?{}[`\"]?.*?;".format(re.escape(table_name_to_find)),
        re.IGNORECASE | re.DOTALL
    )

    for statement_match in insert_statement_regex.finditer(full_content):
        _, mysql_cols, all_rows = _parse_mysql_insert(statement_match.group(0))
        if not mysql_cols:
            continue
        try:
            col_index = mysql_cols.index(column_name_to_find)
            for row in all_rows:
                total_rows += 1
                if col_index < len(row):
                    unique_values.add(row[col_index])
        except (ValueError, IndexError):
            continue
            
    return jsonify({
        "unique_values": sorted(list(v for v in unique_values if v is not None)),
        "total_rows": total_rows
    })

# --- Core Migration Logic ---

def _parse_mysql_insert(statement_chunk):
    """Parses a MySQL INSERT statement into its table name, column list, and row data."""
    header_match = re.search(r"INSERT INTO\s+[`\"]?(\w+)[`\"]?\s*\((.*?)\)\s+VALUES", statement_chunk, re.IGNORECASE | re.DOTALL)
    if not header_match:
        return None, None, None
    
    table_name = header_match.group(1)
    columns = [c.strip().strip('`"') for c in header_match.group(2).split(',')]
    
    values_keyword_match = re.search(r"VALUES", statement_chunk, re.IGNORECASE)
    if not values_keyword_match:
        return table_name, columns, []

    values_full_str = statement_chunk[values_keyword_match.end():]
    value_tuples_regex = re.compile(r"\(( (?: [^()'] | ' (?: \\. | [^'\\] )* ' )*? )\)", re.VERBOSE)
    value_matches = value_tuples_regex.findall(values_full_str)
    
    all_rows = []
    for v_tuple in value_matches:
        values = re.split(r",(?=(?:[^']*'[^']*')*[^']*$)", v_tuple)
        cleaned_values = []
        for v in values:
            v_stripped = v.strip()
            if v_stripped.upper() == 'NULL':
                cleaned_values.append(None)
            elif v_stripped.startswith("'") and v_stripped.endswith("'"):
                cleaned_values.append(v_stripped[1:-1].replace("\\'", "'").replace('\\"', '"').replace('\\\\', '\\'))
            else:
                cleaned_values.append(v_stripped)
        all_rows.append(cleaned_values)
        
    return table_name, columns, all_rows

def _perform_migration(config):
    """
    Performs data migration by first consolidating data from multiple source
    tables into an intermediate structure, and then inserting the merged
    records into the target PostgreSQL database.
    """
    pg_conn = psycopg2.connect(**config['pg_config'])
    pg_cursor = pg_conn.cursor()
    migration_summary = defaultdict(lambda: defaultdict(int, {'errors': []}))
    mapping_rules = config.get('mapping_rules', {})

    # 1. Load all data from the MySQL dump into an in-memory dictionary.
    with open(config['mysql_dump_file_path'], 'r', encoding='utf-8') as f:
        full_content = f.read()
    
    all_data = defaultdict(list)
    insert_statement_regex = re.compile(r"INSERT INTO .*?;\n", re.IGNORECASE | re.DOTALL)
    for statement_match in insert_statement_regex.finditer(full_content):
        mysql_table, mysql_cols, all_rows = _parse_mysql_insert(statement_match.group(0))
        if mysql_table and mysql_cols:
            for row in all_rows:
                if len(mysql_cols) == len(row):
                    all_data[mysql_table].append(dict(zip(mysql_cols, row)))

    # 2. Truncate target tables if requested by the user.
    if config.get('truncate_tables'):
        all_mapped_pg_tables = set(mapping_rules.keys())
        for pg_table in sorted(list(all_mapped_pg_tables), reverse=True):
            print(f"Truncating table: {pg_table}")
            pg_cursor.execute(f'TRUNCATE TABLE "{pg_table}" RESTART IDENTITY CASCADE;')
        pg_conn.commit()
        print("Target tables truncated.")

    # 3. Consolidate data into an intermediate structure.
    # This structure will hold the complete, merged record for each user.
    consolidated_data = {}

    # Phase A: Populate with base data from 'teacher_profile'
    # We assume 'teacher_profile' is the primary source of user identity.
    print("Phase 1: Consolidating data from 'teacher_profile'...")
    for row in all_data.get('teacher_profile', []):
        # The key for consolidation is the 'teacher_id', which should map to 'users.id'
        key = row.get('teacher_id')
        if key is not None:
            consolidated_data[key] = {
                'id': row.get('id'), # This is the teacher_profile.id
                'full_name': row.get('name'),
                'mobile': row.get('phone_no'),
                # Initialize other fields to None; they will be enriched later.
                'email': None,
                'password_hash': None
            }
    print(f" -> Found {len(consolidated_data)} base records from 'teacher_profile'.")

    # Phase B: Enrich with data from the 'users' table
    print("Phase 2: Enriching with data from 'users'...")
    enriched_count = 0
    for row in all_data.get('users', []):
        # The key for enrichment is the 'id' from the 'users' table.
        key = row.get('id')
        if key in consolidated_data:
            consolidated_data[key]['email'] = row.get('email')
            consolidated_data[key]['password_hash'] = row.get('password')
            enriched_count += 1
    print(f" -> Enriched {enriched_count} records with email/password.")

    # 4. Main Logic: Iterate through each TARGET table defined in the mapping rules.
    for pg_table, rules in mapping_rules.items():
        print(f"\nProcessing target table: {pg_table}")

        # 5. Iterate through the consolidated data and insert into the target table.
        for user_id, user_data in consolidated_data.items():
            
            # This dictionary will hold the final values for the PostgreSQL row.
            pg_values_dict = {}

            # Build the row for insertion using the mapping rules and the consolidated data.
            for pg_col, rule in rules.items():
                value_found = None
                if rule['type'] == 'direct':
                    # Map the source column name from the rule to the key in our `user_data` dict
                    source_col = rule['value']
                    if source_col == 'teacher_id': value_found = user_id
                    elif source_col == 'name': value_found = user_data.get('full_name')
                    elif source_col == 'phone_no': value_found = user_data.get('mobile')
                    elif source_col == 'email': value_found = user_data.get('email')
                    elif source_col == 'password': value_found = user_data.get('password_hash')
                    # This handles the mapping of teacher_profile.id to users.id
                    elif source_col == 'id' and rule['source_table'] == 'teacher_profile':
                        value_found = user_data.get('id')
                    else:
                        value_found = user_data.get(source_col)

                elif rule['type'] == 'static':
                    value_found = rule['value']
                
                pg_values_dict[pg_col] = value_found

            # 6. Insert the fully formed row into PostgreSQL.
            final_pg_cols = list(pg_values_dict.keys())
            final_pg_values = list(pg_values_dict.values())
            quoted_columns = ', '.join(f'"{c}"' for c in final_pg_cols)
            placeholders = ", ".join(["%s"] * len(final_pg_cols))
            
            insert_query = f'INSERT INTO "{pg_table}" ({quoted_columns}) VALUES ({placeholders})'
            
            if config.get('handle_conflicts'):
                # Assuming 'id' is the conflict target. This might need to be made more flexible.
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
            except (psycopg2.Error, Exception) as e:
                pg_conn.rollback()
                migration_summary[pg_table]['failed'] += 1
                if len(migration_summary[pg_table]['errors']) < 5:
                    error_str = str(getattr(e, 'pgerror', str(e))).strip()
                    error_detail = {
                        "error": error_str,
                        "query": insert_query,
                        "values": [str(v) for v in final_pg_values]
                    }
                    migration_summary[pg_table]['errors'].append(error_detail)

    pg_conn.close()
    return dict(migration_summary)

if __name__ == '__main__':
    app.run(debug=True)
