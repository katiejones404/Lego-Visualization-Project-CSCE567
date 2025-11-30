PRAGMA foreign_keys = OFF;

-- Drop head data tables
BEGIN;
DROP TABLE IF EXISTS head_data;
DROP TABLE IF EXISTS head_data_categories;
COMMIT;

PRAGMA foreign_keys = ON;
