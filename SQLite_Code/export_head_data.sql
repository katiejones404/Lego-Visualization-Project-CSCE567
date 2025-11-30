.mode csv
.headers on

-- Path to the data folder
.output ../MinifigData/head_data.csv

SELECT
    set_num,
    set_name,
    set_year,
    parent_theme_name,
    part_num,
    part_name,
    element_id,
    element_color_name,
    quantity
FROM head_data
ORDER BY set_year, parent_theme_name, set_num;

.output stdout 

.mode csv
.headers on

-- Path to the data folder
.output ../MinifigData/head_data_categories.csv

SELECT
    set_num,
    set_name,
    set_year,
    parent_theme_name,
    part_num,
    part_name,
    element_id,
    element_color_name,
    skin_tone_group,
    gender_group,
    figure_type,
    quantity
FROM head_data_categories
ORDER BY set_year, parent_theme_name, set_num;

.output stdout 



.mode csv
.headers on

-- Path to the data folder
.output ../MinifigData/themes_by_year.csv

SELECT
    year,
    parent_theme_id,
    parent_theme_name,
    num_sets  
FROM themes_by_year
ORDER BY num_sets, year;

.output stdout 
