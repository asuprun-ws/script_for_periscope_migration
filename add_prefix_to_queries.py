import os
import yaml
import json
import re

# sol = re.sub(r'((F|f)(R|r)(O|o)(M|m)|(J|j)(O|o)(I|i)(N|n))(\s|\t\n)+', r'\1 pantheon.', text_two)
count = 0
for subdir, dirs, files in os.walk("./dashboards"):
    if len(files) == 2:
        print("--------------------------------------")
        print(files)
        for file in files:
            if file.endswith(".sql"):
                sql_file = os.path.join(subdir, file)
            if file.endswith(".yaml"):
                yaml_file = os.path.join(subdir, file)

        with open(yaml_file, 'r') as stream:
            try:
                yaml_args = yaml.safe_load(stream)
                is_microservices_db = True if yaml_args['database_name'] == 'microservices' else False
            except yaml.YAMLError as exc:
                print(exc)
        if not is_microservices_db:
            with open(sql_file, 'r') as f:
                sql_queries = f.read()
                updated_sql_queries = re\
                    .sub(r'((F|f)(R|r)(O|o)(M|m)|(J|j)(O|o)(I|i)(N|n))(\s|\t\n)+', r'\1 pantheon.', sql_queries)
            with open(sql_file, 'w') as f:
                f.write(updated_sql_queries)