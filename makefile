# Local postgres connection parameters
DB_HOST := localhost
DB_PORT := 5432
DB_USER := postgres
DB_PASSWORD := xxxxxxxxxxxxxxxxxx
DB_NAME := mexico

# Database creator parameters
DB_NUSER := m2igast
DB_NUSER_PWD := 'xxxxxxxxxxxxxxxxxx'

# Folder used for the database creation
DATA_FOLDER := ./data
SQL_FOLDER := ./sql
R_FOLDER := ./R
SHP_FOLDER := $(DATA_FOLDER)/shp
SQL_SHP_FOLDER := $(DATA_FOLDER)/ssql

# psql macro
PSQL := @PGPASSWORD=$(DB_PASSWORD) psql -q -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER)

# Data previously cleaned ?
EXIST_CLEANED_FILES := $([ -f "./data/cleaned_census.csv" ] || pretraitment)

# Principal Target (call by 'make' without parameters)
# ====================================================

# 'pretraitment' target is call if the 'cleand_census.csv' file does not exists
all: $(EXIST_CLEANED_FILES) create populate finitions

# Secondary targets (call by 'all' target)
# ========================================
# These targets can be called independently if necessary

# 'pretraitment' target
pretraitment: spliting_data cleaning_data

# 'create' target ; database creation
create: create_db create_user create_geographic_tables create_tables

# 'populate' target ; data insertion
populate: populate_tables populate_geographic_tables

# 'finitions' target ; add grant and constraints in the database
finitions: add_constraints add_grant

# Tertiary targets (call by secondary targets)
# ========================================
# These targets are not made for a direct call

# Call a R script for sliting the census data
spliting_data:
	@echo -n '[R] Spliting data: '
	@$(R_FOLDER)/spliting.r -f $(DATA_FOLDER)/ipumsi_00028.csv -o $(DATA_FOLDER)/splited.csv
	@echo 'Done'

# Call a R script fir cleaning the census data
cleaning_data: spliting_data
	@echo -n '[R] Cleaning data: '
	@$(R_FOLDER)/cleaning.r -f $(DATA_FOLDER)/splited.csv -o $(DATA_FOLDER)/cleaned_census.csv
	@echo 'Done'

# Create the database
create_db:
	@echo -n '[Postgres] Create database: '
	$(PSQL) -c "CREATE DATABASE $(DB_NAME);"
	$(PSQL) -d $(DB_NAME) -c "CREATE EXTENSION postgis;"
	@echo 'Done'

# Create a new user (with the parameters set in the head of the makefile)
create_user:
	@echo -n '[Postgres] Create user: '
	$(PSQL) -d $(DB_NAME) -c "CREATE USER $(DB_NUSER) WITH ENCRYPTED PASSWORD $(DB_NUSER_PWD);"
	@echo 'Done'

# Create census tables
create_tables:
	@echo -n '[Postgres] Create tables: '
	$(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/create_tables.sql
	@echo 'Done'

# Create geographic tables (need the conversion of the shapefile)
create_geographic_tables: convert_shp
	@echo -n '[Postgres] Create geographic table: '
	$(PSQL) -d $(DB_NAME) -f $(SQL_SHP_FOLDER)/c_mexico_lvl2.sql
	@echo 'Done'

# Convert a shapefile in table (only the structure, not the data)
convert_shp:
	@echo -n '[Bash] Convert shapefile: '
	@mkdir -p $(SQL_SHP_FOLDER)
	@shp2pgsql -W LATIN1 -p -s 4326 $(SHP_FOLDER)/geo2_mx1960_2015 public.mexico_lvl2 > $(SQL_SHP_FOLDER)/c_mexico_lvl2.sql
	@echo 'Done'

# Populate database ageographic tables
populate_tables:
	@echo -n '[Postgres] Populate tables: '
	$(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/populate_tables.sql
	$(PSQL) -d $(DB_NAME) -c "\copy dataset_2015 FROM '$(DATA_FOLDER)/cleaned_census.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'NA', HEADER);"
	@echo 'Done'

# Populate database geographic tables (and convert the shape file)
populate_geographic_tables:
	@echo -n '[Postgres] Populate geographic table: '
	@shp2pgsql -W LATIN1 -a -s 4326 $(SHP_FOLDER)/geo2_mx1960_2015 public.mexico_lvl2 > $(SQL_SHP_FOLDER)/mexico_lvl2.sql
	$(PSQL) -d $(DB_NAME) -f $(SQL_SHP_FOLDER)/mexico_lvl2.sql
	@echo 'Done'

# Add constraints to the database
add_constraints:
	@echo -n '[Postgres] Add constraints: '
	$(PSQL) -d $(DB_NAME) -f $(SQL_FOLDER)/constraints.sql
	@echo 'Done'

# Add grant to the database
add_grant:
	@echo -n '[Postgres] Add grant: '
	$(PSQL) -d $(DB_NAME) -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $(DB_NUSER);"
	@echo 'Done'

# Cleaning targets
# ========================================

# Delete the user created by the 'create_user' target
delete_user:
	@echo -n '[Postgres] Delete user: '
	$(PSQL) -c "DROP USER $(DB_NUSER);"
	@echo 'Done'

# Delete the database
delete_db:
	@echo -n '[Postgres] Delete database: '
	$(PSQL) -c "DROP DATABASE $(DB_NAME);"
	@echo 'Done'

# Remove the converted files
clean:
	@echo -n '[Bash] Remove the converted files: '
	@rm -rf $(SQL_SHP_FOLDER)
	@rm -rf $(DATA_FOLDER)/splited.csv 
	@rm -rf $(DATA_FOLDER)/cleaned_census.csv
	@echo 'Done'

# Remove all postgres creations
delete: delete_db delete_user

# Powerfull cleaning, like the dead army 
# in the end of the lord of the rings
mrproper: clean delete
