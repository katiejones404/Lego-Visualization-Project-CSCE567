PRAGMA foreign_keys = OFF;

-- Drop original data tables
BEGIN;
DROP TABLE IF EXISTS colors;
DROP TABLE IF EXISTS elements;
DROP TABLE IF EXISTS inventories;
DROP TABLE IF EXISTS inventory_minifigs;
DROP TABLE IF EXISTS inventory_parts;
DROP TABLE IF EXISTS inventory_sets;
DROP TABLE IF EXISTS minifigs;
DROP TABLE IF EXISTS part_categories;
DROP TABLE IF EXISTS part_relationships;
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS sets;
DROP TABLE IF EXISTS themes;
COMMIT;

PRAGMA foreign_keys = ON;
