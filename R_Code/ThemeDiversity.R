# Usage:
#   Rscript darker_by_theme.R [path/to/db.sqlite] [--by-year (optional)]
# By default, the correct local path will be used
#

suppressPackageStartupMessages({
  library(DBI)
  library(RSQLite)
  library(dplyr)
  library(glue)
  library(readr)
})

args <- commandArgs(trailingOnly = TRUE)

#Parameters
db_path <- "./SQLite_Code/Minifig_Database.db"
compute_by_year <- any(grepl("--by-year", args, ignore.case = TRUE))
out_dir <- "./MinifigData"


cat("DB path:", db_path, "\n")
cat("Compute by year:", compute_by_year, "\n")
cat("Output folder:", out_dir, "\n\n")

con <- dbConnect(RSQLite::SQLite(), db_path)
on.exit({
  try(dbDisconnect(con), silent = TRUE)
})

# detect available table to use
available_tables <- dbListTables(con)

# Prefer head_data_categories if present (already has skin_tone_group), else fallback to resolved/master
use_table <- NULL
if ("head_data_categories" %in% available_tables) {
  use_table <- "head_data_categories"
} else {
  stop("No suitable source table found. Please create 'head_data_categories' or 'resolved' / 'master_minifig_heads_resolved'.")
}
color_to_tone <- data.frame(
  element_color_name = c(
  "Light Nougat",
  "Nougat",                  
  "Medium Tan",              
  "Tan",                     
  "Medium Nougat",           
  "Dark Tan",                
  "Reddish Brown",           
  "Light Brown",             
  "Brown",                   
  "Medium Brown",            
  "Reddish Brown",           
  "Medium Brown",            
  "Dark Brown",             
  "Dark Orange"            
  ),
  skin_tone_group = c(
    "Light",
    "Light",
    "Medium",
    "Medium",
    "Medium",
    "Medium",
    "Dark",
    "Dark",
    "Dark",
    "Dark",
    "Dark",
    "Dark",
    "Dark",
    "Dark"
  )
    
  )

if (use_table == "head_data_categories") {
  q_all <- glue_sql("
    SELECT
      COALESCE(parent_theme_name, 'Unknown') AS parent_theme_name,
      COALESCE(set_year, -1) AS set_year,
      skin_tone_group,
      COALESCE(quantity, 0) AS quantity,
      element_id
    FROM head_data_categories
  ", .con = con)
  df <- dbGetQuery(con, q_all)
} else {
  q_all <- glue_sql("
    SELECT
      COALESCE(COALESCE(tp.name, t.name), 'Unknown') AS parent_theme_name,
      COALESCE(r.set_year, -1) AS set_year,
      r.element_color_name,
      COALESCE(r.quantity, 0) AS quantity,
      r.element_id,
      r.part_num
    FROM {`use_table`} r
    LEFT JOIN themes t ON t.id = r.theme_id
    LEFT JOIN themes tp ON tp.id = t.parent_id
  ", .con = con)
  df_raw <- dbGetQuery(con, q_all)
  
  # Map element_color_name -> skin_tone_group using mapping (exact match)
  df <- df_raw %>%
    left_join(color_to_tone, by = "element_color_name") %>%
    mutate(skin_tone_group = if_else(is.na(skin_tone_group), "Non-human", skin_tone_group)) %>%
    select(parent_theme_name, set_year, skin_tone_group, quantity, element_id)
}

# Define darker tones as 'Medium' or 'Dark'
df_summary <- df %>%
  group_by(parent_theme_name) %>%
  summarise(
    darker_shade_count = sum(if_else(skin_tone_group %in% c("Medium","Dark"), quantity, 0L)),
    total_head_count = sum(quantity),
    unique_darker_elements = n_distinct(if_else(skin_tone_group %in% c("Medium","Dark"), element_id, NA_character_)),
    unique_elements = n_distinct(element_id),
    pct_darker = if_else(total_head_count > 0, round(100.0 * darker_shade_count / total_head_count, 2), 0)
  ) %>%
  arrange(desc(darker_shade_count)) %>%
  ungroup()

out_csv <- file.path(out_dir, "darker_by_theme.csv")
write_csv(df_summary, out_csv)
cat("Wrote:", out_csv, "\n\n")

if (compute_by_year) {
  df_by_year <- df %>%
    group_by(parent_theme_name, set_year) %>%
    summarise(
      darker_shade_count = sum(if_else(skin_tone_group %in% c("Medium","Dark"), quantity, 0L)),
      total_head_count = sum(quantity),
      unique_darker_elements = n_distinct(if_else(skin_tone_group %in% c("Medium","Dark"), element_id, NA_character_)),
      unique_elements = n_distinct(element_id),
      pct_darker = if_else(total_head_count > 0, round(100.0 * darker_shade_count / total_head_count, 2), 0)
    ) %>%
    arrange(parent_theme_name, set_year) %>%
    ungroup()
  
  out_csv_year <- file.path(out_dir, "darker_by_theme_by_year.csv")
  write_csv(df_by_year, out_csv_year)
  cat("Wrote:", out_csv_year, "\n\n")
}

cat("Top 10 themes by darker_shade_count:\n")
print(head(df_summary, 10))

cat("\nDone.\n")

