# Lego-Visualization-Project-CSCE567
My final project for CSCE567

Necessary technologies: SQLite


If you want to download all of the csv files and import all of the tables, please go to the ../RebrickableData/ReadME.md file and follow those steps.
Once those steps have been completed, come back to this file.

1. Set up SQLite database

In the SQLite_Code file, run in order...
- sqlite3.exe Minifig_Database.db
- 



To export as a CSV file:
.mode csv
.headers on
.output minifigure_heads.csv
SELECT * FROM minifigure_heads_by_set;
.output stdout