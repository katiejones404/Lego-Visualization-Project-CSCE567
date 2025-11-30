-- import_all.sql
.mode csv
.headers on

-- Import files (one by one). Works if heading matches columns
.import --skip 1 ../RebrickableData/part_categories.csv part_categories
.import --skip 1 ../RebrickableData/colors.csv colors
.import --skip 1 ../RebrickableData/themes.csv themes

.import ../RebrickableData/parts.csv parts
.import ../RebrickableData/part_relationships.csv part_relationships
.import --skip 1 ../RebrickableData/elements.csv elements

.import ../RebrickableData/sets.csv sets
.import ../RebrickableData/minifigs.csv minifigs

.import --skip 1 ../RebrickableData/inventories.csv inventories
.import ../RebrickableData/inventory_parts.csv inventory_parts
.import ../RebrickableData/inventory_minifigs.csv inventory_minifigs
.import ../RebrickableData/inventory_sets.csv inventory_sets
