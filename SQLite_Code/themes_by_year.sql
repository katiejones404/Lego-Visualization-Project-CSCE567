DROP TABLE IF EXISTS themes_by_year;

CREATE TABLE themes_by_year AS
SELECT
    s.year,
    
    -- parent theme ID, if no parent theme id, default to theme id.
    COALESCE(tp.id, t.id) AS parent_theme_id,
    
    -- parent theme name, if no parent theme name, default to theme name.
    COALESCE(tp.name, t.name) AS parent_theme_name,
    
    COUNT(*) AS num_sets
FROM sets s
LEFT JOIN themes t 
       ON t.id = s.theme_id
LEFT JOIN themes tp 
       ON tp.id = t.parent_id
WHERE s.year IS NOT NULL
GROUP BY 
    s.year,
    COALESCE(tp.id, t.id),
    COALESCE(tp.name, t.name)
ORDER BY 
    s.year,
    num_sets DESC;
