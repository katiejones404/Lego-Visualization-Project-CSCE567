#SQLite database file
DB = Minifig_Database.db

#SQLITE version
SQLITE = sqlite3

#Default, everything
all: build

# Clean + rebuild database from scratch
build: clean create import transform export
	@echo "All done building LEGO minifigure head dataset!"

#Step 1: create tables
create:
	@echo "Creating tables..."
	$(SQLITE) $(DB) ".read create_tables.sql"

# Step 2: import all CSVs
import:
	@echo "Importing all CSVs..."
	$(SQLITE) $(DB) ".read import_all.sql"

# Step 3: build minifigure head data tables
transform:
	@echo "Getting minifig data"
	$(SQLITE) $(DB) ".read head_data.sql"
	$(SQLITE) $(DB) ".read derive_categories.sql"
	$(SQLITE) $(DB) ".read themes_by_year.sql"

# Step 4: export CSVs to folder ./exports
export:
	@echo "Exporting CSV files..."
	$(SQLITE) $(DB) ".read export_head_data.sql"

#Clean: remove the database file so everything regenerates
clean:
	@echo "Removing existing database..."
	rm -f $(DB)

#DropCore: drop the core tables
dropcore: 
	@echo "Deleting core tables"
	$(SQLITE) $(DB) ".read drop_original_data_tables.sql"

dropfig: 
	@echo "Deleting minifig tables"
	$(SQLITE) $(DB) ".read drop_minifig_data_tables.sql"

.PHONY: all build clean create import transform export clean_exports
