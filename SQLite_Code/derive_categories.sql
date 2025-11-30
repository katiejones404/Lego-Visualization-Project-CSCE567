DROP TABLE IF EXISTS head_data_categories;

CREATE TABLE head_data_categories AS
SELECT
    r.set_num,
    r.set_name,
    r.set_year,
    r.parent_theme_name,
    r.part_num,
    r.part_name,
    r.element_id,
    r.element_color_name,
    r.quantity,

    -- --- SKIN TONE CATEGORY ---
    CASE
        WHEN r.element_color_name = 'Light Nougat' THEN 'Light'
        WHEN r.element_color_name = 'Nougat' THEN 'Light'
        WHEN r.element_color_name = 'Tan' THEN 'Medium'        
        WHEN r.element_color_name = 'Medium Nougat' THEN 'Medium'
        WHEN r.element_color_name = 'Medium Tan' THEN 'Medium'
        WHEN r.element_color_name = 'Dark Tan' THEN 'Medium'
        WHEN r.element_color_name = 'Light Brown' THEN 'Dark'
        WHEN r.element_color_name = 'Reddish Brown' THEN 'Dark'
        WHEN r.element_color_name = 'Medium Brown' THEN 'Dark'
        WHEN r.element_color_name = 'Brown' THEN 'Dark'
        WHEN r.element_color_name = 'Dark Orange' THEN 'Dark'
        WHEN r.element_color_name = 'Dark Brown' THEN 'Dark'
        WHEN r.element_color_name = 'Yellow' THEN 'Yellow'        


        ELSE 'Non-human'
    END AS skin_tone_group,

    -- --- GENDER CATEGORY ---
    CASE
        WHEN r.part_name LIKE '%Female%' THEN 'Female'
        WHEN r.part_name LIKE '%Girl%' THEN 'Female'
        WHEN r.part_name LIKE '%Boy%' THEN 'Male'
        WHEN r.part_name LIKE '%Male%' THEN 'Male'
        WHEN r.part_name LIKE '%Woman%' THEN 'Female'
        WHEN r.part_name LIKE '%Man%' THEN 'Male'
        WHEN r.part_name LIKE '%Lord%' THEN 'Male'
        WHEN r.part_name LIKE '%Princess%' THEN 'Female'
        WHEN r.part_name LIKE '%Queen%' THEN 'Female'
        WHEN r.part_name LIKE '%King%' THEN 'Male'
        -- else unknown / creature / robot / skeleton
        ELSE 'Unknown'
    END AS gender_group,

    -- --- FIGURE TYPE (minifigure vs minidoll) ---
    CASE
        WHEN pc.id = 59 THEN 'Minifigure'
        WHEN pc.id = 62 THEN 'Minidoll'
        ELSE 'Other'
    END AS figure_type

FROM head_data r
JOIN parts p ON p.part_num = r.part_num
JOIN part_categories pc ON pc.id = p.part_cat_id
;
