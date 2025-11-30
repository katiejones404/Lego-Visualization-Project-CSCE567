PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

-- drop any previous tables
DROP TABLE IF EXISTS head_data;
DROP TABLE IF EXISTS tmp_ip_orig;
DROP TABLE IF EXISTS tmp_ip_with_parent;


-- Part numbers for minifigure heads correspond to an inventory_id in the inventory_parts table,
--  this inventory_id corresponds with an id in the inventories table, however the set_num in the inventories table
--  corresponds to a figure number, and not a set. 
-- To get the actual set_num that this minifigure part is from, we must use the set_num from the inventories table. 
-- The set_num corresponds to a figure number (fig_num) in the inventory_minifigs table. 
-- We must find the fig_num in the inventory_minifigs table, in the row there will be a inventory_id.
-- This inventory_id corresponds to an id in the inventories table, which corresponds to the correct set_num for the piece.


-- 1) ip_orig: attach the original inventories.set_num for every inventory_parts row
CREATE TEMP TABLE tmp_ip_orig AS
SELECT
  ip.*,
  i.set_num AS orig_setnum
FROM inventory_parts ip
JOIN inventories i ON i.id = ip.inventory_id
;

-- 2) ip_with_parent: if orig_setnum is a fig (fig-...), find the parent inventory that contains that fig
CREATE TEMP TABLE tmp_ip_with_parent AS
SELECT
  o.*,
  im.inventory_id AS parent_inventory_id,
  parent_inv.set_num AS parent_setnum,
  COALESCE(parent_inv.set_num, o.orig_setnum) AS resolved_set_num
FROM tmp_ip_orig o
LEFT JOIN inventory_minifigs im ON im.fig_num = o.orig_setnum
LEFT JOIN inventories parent_inv ON parent_inv.id = im.inventory_id
;

-- 3) Create the resolved master table from the temp table
CREATE TABLE head_data AS
SELECT
  pwp.resolved_set_num AS set_num,
  s.name AS set_name,
  s.year AS set_year,
  COALESCE(tp.id, t.id) AS parent_theme_id,
  COALESCE(tp.name, t.name) AS parent_theme_name,
  p.part_num,
  p.name AS part_name,
  e.element_id,
  e.color_id AS element_color_id,
  c.name AS element_color_name,
  pc.id,
  pc.name,
  SUM(COALESCE(pwp.quantity,0)) AS quantity,
  MIN(pwp.img_url) AS img_url
FROM tmp_ip_with_parent pwp
JOIN parts p ON p.part_num = pwp.part_num
JOIN part_categories pc ON pc.id = p.part_cat_id
JOIN elements e ON e.part_num = p.part_num AND e.color_id = pwp.color_id
LEFT JOIN colors c ON c.id = e.color_id
LEFT JOIN sets s ON s.set_num = pwp.resolved_set_num
LEFT JOIN themes t ON t.id = s.theme_id
LEFT JOIN themes tp ON tp.id = t.parent_id
-- Minifigure heads have pc.id = 59
-- Minidoll heads (like heads in the Lego Friends theme) have pc.id = 62
WHERE pc.id IN (59, 62)
GROUP BY
  pwp.resolved_set_num,
  e.element_id
;

-- indexes
CREATE INDEX IF NOT EXISTS idx_resolved_setnum ON head_data(set_num);
CREATE INDEX IF NOT EXISTS idx_resolved_element ON head_data(element_id);

COMMIT;
PRAGMA foreign_keys = ON;
