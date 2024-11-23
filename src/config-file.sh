!/bin/bash

# Variables de connexion PostgreSQL
DB_NAME="simpluedo"
DB_USER="ayoublaroussi"
DB_HOST="localhost"
DB_PORT="5432"

psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/create.sql postgres
psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/insert.sql simpluedo
psql -U "$DB_USER" -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/trigger.sql simpluedo

pgcli -u admin_simpluedo -d simpluedo