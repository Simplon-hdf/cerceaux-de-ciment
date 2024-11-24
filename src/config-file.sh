!/bin/bash

# Variables de connexion PostgreSQL
DB_NAME="simpluedo"
DB_USER="ayoublaroussi"

psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/sql/create.sql postgres
psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/sql/insert.sql "$DB_NAME"
psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/sql/trigger.sql "$DB_NAME"

pgcli -u admin_simpluedo -d simpluedo