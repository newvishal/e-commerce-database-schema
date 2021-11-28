#!/bin/bash
set -e

# <-- Create Development Database -->

# \i <filename>  --to run (include) a script file of SQL commands.
# \c <database>  --to connect to a different database
# Copy init.sql file to a docker volume in /var/lib/data/init.sql to gain access to init.sql inside the container.

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $POSTGRES_READ_USER WITH PASSWORD '$POSTGRES_READ_USER_PASSWORD';
    CREATE USER $POSTGRES_CREATE_USER WITH PASSWORD '$POSTGRES_CREATE_USER_PASSWORD';
    CREATE USER $POSTGRES_UPDATE_USER WITH PASSWORD '$POSTGRES_UPDATE_USER_PASSWORD';
    CREATE USER $POSTGRES_DELETE_USER WITH PASSWORD '$POSTGRES_DELETE_USER_PASSWORD';
    
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $POSTGRES_READ_USER;
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $POSTGRES_CREATE_USER;
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $POSTGRES_UPDATE_USER;
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $POSTGRES_DELETE_USER;
    GRANT USAGE ON SCHEMA public TO $POSTGRES_READ_USER;
    GRANT USAGE ON SCHEMA public TO $POSTGRES_CREATE_USER;
    GRANT USAGE ON SCHEMA public TO $POSTGRES_UPDATE_USER;
    GRANT USAGE ON SCHEMA public TO $POSTGRES_DELETE_USER;
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO $POSTGRES_READ_USER;
    GRANT INSERT ON ALL TABLES IN SCHEMA public TO $POSTGRES_CREATE_USER;
    GRANT SELECT, UPDATE  ON ALL TABLES IN SCHEMA public TO $POSTGRES_UPDATE_USER;
    GRANT SELECT, DELETE ON ALL TABLES IN SCHEMA public TO $POSTGRES_DELETE_USER;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_READ_USER;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_CREATE_USER;
    GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_UPDATE_USER;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_DELETE_USER;
EOSQL
