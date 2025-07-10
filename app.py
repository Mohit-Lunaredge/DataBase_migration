import psycopg2
import re
import json
import sys
import os
import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
from collections import defaultdict

# --- Flask App Initialization ---
app = Flask(__name__)
CORS(app)

# --- Constants ---
SQL_FILES_DIR = "sql_files"
MAPPINGS_DIR = "mappings"
LOGS_DIR = "logs"

def _initialize_directories():
    """Ensure all necessary directories exist."""
    for directory in [SQL_FILES_DIR, MAPPINGS_DIR, LOGS_DIR]:
        os.makedirs(directory, exist_ok=True)

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
    """Lists all .sql files in the predefined SQL_FILES_DIR."""
    _initialize_directories()
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
        import traceback
        traceback.print_exc()
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

@app.route('/api/get_source_table_data', methods=['POST'])
def get_source_table_data():
    """Parses a MySQL dump to extract all data for a specific table."""
    data = request.json
    filename = data.get('filename')
    custom_path = data.get('path')
    table_name_to_find = data.get('tableName')

    if not (filename or custom_path) or not table_name_to_find:
        return jsonify({"error": "File path and table name are required."}), 400

    filepath = custom_path if custom_path else os.path.join(SQL_FILES_DIR, filename)
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            full_content = f.read()
    except FileNotFoundError:
        return jsonify({"error": f"File not found on server at path: {filepath}"}), 404
    except Exception as e:
        return jsonify({"error": f"An error occurred while reading the file: {str(e)}"}), 500

    table_data = []
    headers = []
    insert_statement_regex = re.compile(
        r"INSERT INTO\s+[`\"]?{}[`\"]?.*?;".format(re.escape(table_name_to_find)),
        re.IGNORECASE | re.DOTALL
    )
    for statement_match in insert_statement_regex.finditer(full_content):
        _, mysql_cols, all_rows = _parse_mysql_insert(statement_match.group(0))
        if not headers and mysql_cols:
            headers = mysql_cols
        if mysql_cols and all_rows:
            for row in all_rows:
                table_data.append(dict(zip(mysql_cols, row)))

    return jsonify({"headers": headers, "rows": table_data})

# --- Mapping & Log Endpoints ---

@app.route('/api/save_mapping', methods=['POST'])
def save_mapping():
    """Saves the current mapping configuration to a JSON file."""
    data = request.json
    name = data.get('name')
    config = data.get('config')
    if not name or not config:
        return jsonify({"error": "Mapping name and config are required."}), 400
    
    try:
        _initialize_directories()
        safe_name = "".join([c for c in name if c.isalpha() or c.isdigit() or c in (' ', '_', '-')]).rstrip()
        if not safe_name:
            return jsonify({"error": "Invalid mapping name."}), 400
        
        filepath = os.path.join(MAPPINGS_DIR, f"{safe_name}.json")
        with open(filepath, 'w') as f:
            json.dump(config, f, indent=4)
        return jsonify({"message": f"Mapping '{safe_name}' saved successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/get_mappings', methods=['GET'])
def get_mappings():
    """Lists all saved mapping configuration files."""
    _initialize_directories()
    try:
        files = [f.replace('.json', '') for f in os.listdir(MAPPINGS_DIR) if f.endswith('.json')]
        return jsonify(sorted(files))
    except Exception as e:
        return jsonify({"error": f"Failed to list mappings: {str(e)}"}), 500

@app.route('/api/load_mapping/<name>', methods=['GET'])
def load_mapping(name):
    """Loads a specific mapping configuration file."""
    try:
        filepath = os.path.join(MAPPINGS_DIR, f"{name}.json")
        if os.path.exists(filepath):
            with open(filepath, 'r') as f:
                config = json.load(f)
            return jsonify(config)
        else:
            return jsonify({"error": "Mapping not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/get_migration_logs', methods=['GET'])
def get_migration_logs():
    """Lists all saved migration log files."""
    _initialize_directories()
    try:
        files = [f for f in os.listdir(LOGS_DIR) if f.endswith('.json')]
        return jsonify(sorted(files, reverse=True))
    except Exception as e:
        return jsonify({"error": f"Failed to list log files: {str(e)}"}), 500

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

def _check_where_condition(row_dict, where_clause):
    """Checks if a data row meets the conditions of a user-defined WHERE clause."""
    if not where_clause:
        return True
    conditions = re.split(r'\s+AND\s+', where_clause, flags=re.IGNORECASE)
    for condition in conditions:
        match = re.match(r"(\w+)\s*(!=| =)\s*(.*)", condition.strip())
        if not match:
            continue
        col, op, val = match.groups()
        val = val.strip().strip("'\"")
        row_val_str = str(row_dict.get(col)) if row_dict.get(col) is not None else ''
        if op == '=' and row_val_str != val:
            return False
        if op == '!=' and row_val_str == val:
            return False
    return True

def _apply_replacements(value, rules):
    """Applies find-and-replace rules to a single value."""
    if value is None: return None
    val_str = str(value)
    for rule in rules:
        if val_str == rule.get('find'):
            return rule.get('replace')
    return value

def _sort_key_helper(item, column):
    """A helper function to create a sort key that handles None, numbers, and strings."""
    value = item.get(column)
    if value is None:
        return (0, float('-inf')) # Group None values first
    try:
        return (1, float(value))
    except (ValueError, TypeError):
        return (2, str(value))

# --- Helper Functions ---

def _convert_role_to_int(value):
    """
    Converts a role string value to its corresponding integer.
    Useful for handling role_id fields that expect integers but receive strings.
    """
    if not value or not isinstance(value, str):
        return value
        
    role_map = {
        'admin': 1,
        'teacher': 2,
        'student': 3,
    }
    
    lower_value = value.lower()
    if lower_value in role_map:
        return role_map[lower_value]
    
    try:
        return int(value)
    except (ValueError, TypeError):
        return value

def _apply_transformation(source_row, rule, counters, pg_table, pg_col):
    """
    Applies transformations to source data according to mapping rules.
    """
    if rule.get('transform') == 'convertRoleToInt':
        source_value = source_row.get(rule['value'])
        return _convert_role_to_int(source_value)
        
    if rule['function'] == 'CONCAT':
        final_parts = []
        if 'parts' not in rule.get('params', {}):
            return None

        for part in rule['params']['parts']:
            part_type = part.get('type')
            if part_type == 'column':
                val = source_row.get(part.get('value'), '')
                final_parts.append(str(val) if val is not None else '')
            elif part_type in ['static', 'separator']:
                final_parts.append(str(part.get('value', '')))
            elif part_type == 'auto-increment':
                # Create a unique key for the counter for this specific transformation
                counter_key = f"{pg_table}.{pg_col}.concat.{part.get('key', 'default_key')}"
                if counter_key not in counters:
                    counters[counter_key] = part.get('start', 1)
                
                current_val = counters[counter_key]
                final_parts.append(str(current_val))
                counters[counter_key] += part.get('step', 1)

        return "".join(final_parts)
    return None

def _apply_post_transformations(value, rule):
    """Applies post-processing transformations like date formatting and type casting."""
    if value is None:
        return None

    post_transform_rule = rule.get('post_transform')
    if not post_transform_rule:
        return value

    transformed_value = value

    # 1. Date Formatting
    date_format_rule = post_transform_rule.get('date_format')
    if date_format_rule and date_format_rule.get('from') and date_format_rule.get('to'):
        try:
            # First, try to parse the date from the given format
            date_obj = datetime.datetime.strptime(str(transformed_value), date_format_rule['from'])
            # Then, format it to the new format
            transformed_value = date_obj.strftime(date_format_rule['to'])
        except (ValueError, TypeError):
            # If parsing fails, just keep the original value and proceed
            pass

    # 2. Type Casting
    cast_to_type = post_transform_rule.get('cast_to')
    if cast_to_type:
        try:
            if cast_to_type == 'integer':
                transformed_value = int(float(transformed_value))
            elif cast_to_type == 'float':
                transformed_value = float(transformed_value)
            elif cast_to_type == 'string':
                transformed_value = str(transformed_value)
            elif cast_to_type == 'boolean':
                # Handle common boolean string representations
                if str(transformed_value).lower() in ['true', 't', '1', 'yes', 'y']:
                    transformed_value = True
                else:
                    transformed_value = False
        except (ValueError, TypeError):
            # If casting fails, return the value as it was before casting
            pass
            
    return transformed_value

def _apply_fallback_rules(value, rule, counters, pg_table, pg_col):
    """Applies fallback rules if the primary value is None or an empty string."""
    if value is not None and value != '':
        return value

    fallback_rule = rule.get('on_null')
    if not fallback_rule:
        return None
        
    if fallback_rule['type'] == 'set_null':
        return None
    if fallback_rule['type'] == 'static':
        return fallback_rule.get('value')
    if fallback_rule['type'] == 'auto-increment':
        counter_key = f"{pg_table}.{pg_col}.fallback"
        if counter_key not in counters:
            counters[counter_key] = fallback_rule.get('start', 1)
        current_val = counters[counter_key]
        counters[counter_key] += fallback_rule.get('step', 1)
        return current_val
        
    return None

def _execute_custom_commands(cursor, commands_str, summary, command_type):
    """Executes a block of semi-colon separated SQL commands."""
    if not commands_str:
        return
    
    print(f"Executing {command_type} commands...")
    summary_key = f"{command_type}_commands"
    summary[summary_key] = {'executed': [], 'errors': []}
    
    commands = [cmd.strip() for cmd in commands_str.split(';') if cmd.strip()]
    for cmd in commands:
        try:
            cursor.execute(cmd)
            summary[summary_key]['executed'].append(cmd)
            print(f" -> Success: {cmd}")
        except Exception as e:
            error_str = str(getattr(e, 'pgerror', str(e))).strip()
            summary[summary_key]['errors'].append({'command': cmd, 'error': error_str})
            print(f" -> Error executing command '{cmd}': {error_str}")
            # Stop execution of further commands in this block if one fails
            raise e

def _perform_migration(config):
    """
    Performs data migration by iterating through target tables, determining a
    primary source table, and applying all defined mapping rules including
    direct, lookup, and transformation to build and insert records.
    """
    pg_conn = psycopg2.connect(**config['pg_config'])
    pg_cursor = pg_conn.cursor()
    migration_summary = defaultdict(lambda: defaultdict(int, {'errors': []}))
    mapping_rules = config.get('mapping_rules', {})
    filters = config.get('filters', {})

    try:
        _execute_custom_commands(pg_cursor, config.get('pre_migration_commands'), migration_summary, 'pre_migration')
        pg_conn.commit()

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

        print("Pre-processing source data with replacement rules...")
        for source_table, table_filters in filters.items():
            if 'replacements' in table_filters and source_table in all_data:
                replacement_map = table_filters['replacements']
                if not replacement_map: continue

                processed_rows = []
                for row in all_data[source_table]:
                    new_row = row.copy()
                    for col_to_replace, rules in replacement_map.items():
                        if col_to_replace in new_row:
                            new_row[col_to_replace] = _apply_replacements(new_row[col_to_replace], rules)
                    processed_rows.append(new_row)
                
                all_data[source_table] = processed_rows
                print(f" -> Applied replacement rules to table: {source_table}")

        if config.get('truncate_tables'):
            all_mapped_pg_tables = {pg_table for pg_table in mapping_rules.keys()}
            for pg_table in sorted(list(all_mapped_pg_tables), reverse=True):
                print(f"Truncating table: {pg_table}")
                pg_cursor.execute(f'TRUNCATE TABLE "{pg_table}" RESTART IDENTITY CASCADE;')
                pg_conn.commit()
            print("Target tables truncated.")

        counters = {}
        cached_target_lookups = {}
        aggregated_data_cache = {}

        for pg_table in mapping_rules.keys():
            rules = mapping_rules[pg_table]
            for pg_col, rule in rules.items():
                if rule.get('type') == 'group_and_aggregate':
                    source_table = rule['source_table']
                    group_by_col = rule['group_by_column']
                    aggregate_col = rule['aggregate_column']
                    
                    print(f" -> Pre-aggregating for {pg_table}.{pg_col} from {source_table}")
                    
                    cache_key = f"{source_table}_{group_by_col}_{aggregate_col}"
                    if cache_key in aggregated_data_cache:
                        continue

                    aggregation_map = defaultdict(list)
                    for row in all_data.get(source_table, []):
                        group_key = row.get(group_by_col)
                        agg_value = row.get(aggregate_col)
                        if group_key is not None:
                            aggregation_map[group_key].append(agg_value)
                    
                    aggregated_data_cache[cache_key] = dict(aggregation_map)
                    print(f"  - Cached {len(aggregated_data_cache[cache_key])} groups.")

        for pg_table in mapping_rules.keys():
            rules = mapping_rules[pg_table]
            print(f"\nProcessing target table: {pg_table}")

            source_tables_involved = set()
            for _, rule in rules.items():
                if rule.get('source_table'):
                    source_tables_involved.add(rule['source_table'])

            if not source_tables_involved:
                print(f" -> No source tables found for {pg_table}. Skipping.")
                continue
            
            print(f" -> Source tables involved: {', '.join(source_tables_involved)}")

            iteration_data = []
            if len(source_tables_involved) > 1:
                print(" -> Multiple source tables found. Merging data...")
                merged_source_data = defaultdict(dict)
                primary_merge_key_processed = set()
                
                primary_source_table = list(source_tables_involved)[0]

                for row in all_data.get(primary_source_table, []):
                    merge_key_col = filters.get(primary_source_table, {}).get('merge_key', 'id')
                    merge_key = row.get(merge_key_col)
                    if merge_key is not None and merge_key not in primary_merge_key_processed:
                        merged_row = row.copy()
                        for other_table in source_tables_involved - {primary_source_table}:
                            other_merge_key_col = filters.get(other_table, {}).get('merge_key', 'id')
                            for other_row in all_data.get(other_table, []):
                                if other_row.get(other_merge_key_col) == merge_key:
                                    merged_row.update(other_row)
                        iteration_data.append(merged_row)
                        primary_merge_key_processed.add(merge_key)
                print(f" -> Merged into {len(iteration_data)} unique records.")

            else:
                primary_source_table = list(source_tables_involved)[0]
                print(f" -> Single source table identified: {primary_source_table}")
                iteration_data = all_data[primary_source_table]
                
                table_filters = filters.get(primary_source_table, {})
                if 'where' in table_filters and table_filters['where']:
                    filtered_rows = [row for row in iteration_data if _check_where_condition(row, table_filters['where'])]
                    migration_summary[pg_table]['filtered_out'] += len(iteration_data) - len(filtered_rows)
                    iteration_data = filtered_rows
                
                if 'sort' in table_filters and table_filters['sort'].get('column'):
                    sort_settings = table_filters['sort']
                    iteration_data.sort(key=lambda item: _sort_key_helper(item, sort_settings['column']), reverse=(sort_settings.get('order', 'ASC').upper() == 'DESC'))

            indexed_source_lookups = {}
            for _, rule in rules.items():
                if rule['type'] == 'lookup':
                    lookup_source_table = rule['lookup_source_table']
                    where_col = rule['where_col']
                    index_key = f"source_{lookup_source_table}_{where_col}"
                    if index_key not in indexed_source_lookups:
                        print(f" -> Indexing SOURCE table {lookup_source_table} on column {where_col} for lookups.")
                        indexed_source_lookups[index_key] = {
                            str(row.get(where_col)): row
                            for row in all_data.get(lookup_source_table, [])
                            if where_col in row and row.get(where_col) is not None
                        }
            
            for _, rule in rules.items():
                if rule['type'] == 'target_lookup':
                    lookup_table = rule['lookup_table']
                    if lookup_table not in cached_target_lookups:
                        print(f" -> Caching TARGET table {lookup_table} for lookups.")
                        try:
                            pg_cursor.execute(f'SELECT * FROM "{lookup_table}"')
                            lookup_data = [dict(zip([desc[0] for desc in pg_cursor.description], row)) for row in pg_cursor.fetchall()]
                            cached_target_lookups[lookup_table] = {
                                str(row.get(rule['where_col'])): row
                                for row in lookup_data if rule['where_col'] in row
                            }
                            print(f" - Cached {len(cached_target_lookups[lookup_table])} rows.")
                        except Exception as e:
                            print(f" - ERROR: Could not cache target table {lookup_table}. Error: {e}")
                            migration_summary[pg_table]['errors'].append({"error": f"Failed to cache target lookup table {lookup_table}: {e}"})

            for source_row in iteration_data:
                pg_values_dict = {}
                for pg_col, rule in rules.items():
                    value_found = None
                    try:
                        if rule['type'] == 'direct':
                            value_found = source_row.get(rule['value'])
                        elif rule['type'] == 'group_and_aggregate':
                            group_by_col = rule['group_by_column']
                            key_from_source_row = source_row.get(group_by_col)
                            cache_key = f"{rule['source_table']}_{group_by_col}_{rule['aggregate_column']}"
                            value_found = aggregated_data_cache.get(cache_key, {}).get(key_from_source_row, [])
                        elif rule['type'] == 'transformation':
                            value_found = _apply_transformation(source_row, rule, counters, pg_table, pg_col)
                        elif rule['type'] == 'lookup':
                            match_value = str(source_row.get(rule['match_col']))
                            index_key = f"source_{rule['lookup_source_table']}_{rule['where_col']}"
                            lookup_row = indexed_source_lookups.get(index_key, {}).get(match_value)
                            value_found = lookup_row.get(rule['get_col']) if lookup_row else rule.get('default', None)
                        elif rule['type'] == 'target_lookup':
                            match_value = str(source_row.get(rule['match_col']))
                            lookup_cache = cached_target_lookups.get(rule['lookup_table'], {})
                            target_row = lookup_cache.get(match_value)
                            value_found = target_row.get(rule['get_col']) if target_row else rule.get('default', None)
                        elif rule['type'] == 'basic_target_lookup':
                            query = f'SELECT "{rule["get_col"]}" FROM "{rule["lookup_table"]}"'
                            params = []
                            if rule.get('where_clause'):
                                where_clause = rule['where_clause'].replace('{value}', '%s')
                                query += f" WHERE {where_clause}"
                                params.append(source_row.get(rule['match_col']))
                            if rule.get('order_by_clause'):
                                if re.match(r'^[a-zA-Z0-9_,\s]+$', rule['order_by_clause']):
                                    query += f" ORDER BY {rule['order_by_clause']}"
                            query += " LIMIT 1"
                            pg_cursor.execute(query, tuple(params))
                            result = pg_cursor.fetchone()
                            value_found = result[0] if result else rule.get('default', None)
                        elif rule['type'] == 'static':
                            value_found = rule['value']
                        elif rule['type'] == 'auto-increment':
                            counter_key = f"{pg_table}.{pg_col}"
                            if counter_key not in counters:
                                counters[counter_key] = rule.get('start', 1)
                            value_found = counters[counter_key]
                            counters[counter_key] += rule.get('step', 1)

                    except Exception as e:
                        print(f"Error processing rule for {pg_table}.{pg_col}: {e}")
                    
                    # Apply post-processing transformations
                    processed_value = _apply_post_transformations(value_found, rule)
                    
                    # Apply fallbacks if the processed value is null/empty
                    final_value = _apply_fallback_rules(processed_value, rule, counters, pg_table, pg_col)
                    
                    pg_values_dict[pg_col] = final_value

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
                except (psycopg2.Error, Exception) as e:
                    pg_conn.rollback()
                    migration_summary[pg_table]['failed'] += 1
                    if len(migration_summary[pg_table]['errors']) < 5:
                        error_str = str(getattr(e, 'pgerror', str(e))).strip()
                        error_detail = {
                            "error": error_str,
                            "query": pg_cursor.mogrify(insert_query, tuple(final_pg_values)).decode('utf-8', errors='ignore'),
                            "values": [str(v) for v in final_pg_values]
                        }
                        migration_summary[pg_table]['errors'].append(error_detail)

            pg_conn.commit()
        
        _execute_custom_commands(pg_cursor, config.get('post_migration_commands'), migration_summary, 'post_migration')
        pg_conn.commit()

    finally:
        pg_conn.close()

    try:
        _initialize_directories()
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        log_filename = f"migration_log_{timestamp}.json"
        log_filepath = os.path.join(LOGS_DIR, log_filename)
        
        log_data = {
            "timestamp": timestamp,
            "migration_config": {
                "source_file": config.get('mysql_dump_file_path'),
                "target_db": config.get('pg_config', {}).get('dbname'),
                "truncated_tables": config.get('truncate_tables'),
                "handled_conflicts": config.get('handle_conflicts'),
            },
            "summary": dict(migration_summary)
        }
        
        with open(log_filepath, 'w') as f:
            json.dump(log_data, f, indent=4)
        print(f"Migration log saved to {log_filepath}")
    except Exception as e:
        print(f"Error saving migration log: {e}", file=sys.stderr)

    return dict(migration_summary)

if __name__ == '__main__':
    _initialize_directories()
    app.run(debug=True, host='0.0.0.0', port=5000)
