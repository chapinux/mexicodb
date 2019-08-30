DB_HOST := localhost
DB_PORT := 5432
DB_USER := postgres
DB_PASSWORD := xxxxxxxxxxxxxxxxx
DB_NAME := mexico

DB_NUSER := m2igast
DB_NUSER_PWD := xxxxxxxxxxxxxxxxx

DATA_FOLDER := ./data
SQL_FOLDER := ./sql
SHP_FOLDER := $(DATA_FOLDER)/shp
SQL_SHP_FOLDER := $(DATA_FOLDER)/ssql

PSQL := PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER)

all: create populate finitions

create: create_db create_user create_geographic_tables create_tables

populate: populate_tables populate_geographic_tables

finitions: add_constraints add_grant

create_db:
	 $(PSQL) -c "CREATE DATABASE $(DB_NAME);"
	 $(PSQL) -d $(DB_NAME) -c "CREATE EXTENSION postgis;"

create_user:
	 $(PSQL) -d $(DB_NAME) -c "CREATE USER $(DB_NUSER) WITH ENCRYPTED PASSWORD $(DB_NUSER_PWD);"

create_tables:
	 $(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/create_tables.sql

create_geographic_tables: convert_shp
	 $(PSQL) -d $(DB_NAME) -f $(SQL_SHP_FOLDER)/c_mexico_lvl2.sql

convert_shp:
	mkdir -p $(SQL_SHP_FOLDER)
	shp2pgsql -W LATIN1 -p -s 4326 $(SHP_FOLDER)/geo2_mx1960_2015 public.mexico_lvl2 > $(SQL_SHP_FOLDER)/c_mexico_lvl2.sql

populate_tables:
	 $(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/populate_tables.sql
	 $(PSQL) -d $(DB_NAME) -c "\copy dataset_2015 FROM '$(DATA_FOLDER)/mexico2015_NA_insteadof_NIU.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'NA', HEADER);"

populate_geographic_tables:
	shp2pgsql -W LATIN1 -a -s 4326 $(SHP_FOLDER)/geo2_mx1960_2015 public.mexico_lvl2 > $(SQL_SHP_FOLDER)/mexico_lvl2.sql
	 $(PSQL) -d $(DB_NAME) -f $(SQL_SHP_FOLDER)/mexico_lvl2.sql

add_constraints:
	 $(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/constraints.sql

add_grant:
	$(PSQL) -d $(DB_NAME) -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_NUSER);"

delete_user:
	 $(PSQL) -c "DROP USER $(DB_NUSER);"

delete_db:
	 $(PSQL) -c "DROP DATABASE $(DB_NAME);"

clean:
	rm -rf $(SQL_SHP_FOLDER)

delete: delete_db delete_user

mrproper: clean delete
