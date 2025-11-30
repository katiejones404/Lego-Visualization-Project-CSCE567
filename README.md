# Lego-Visualization-Project-CSCE567
My final project for CSCE567

The CSVs produced by the SQL code is in the MinifigData folder. If you would like to modify the data, please use the instructions in this ReadMe and the RebrickableData ReadME (necessity for this described below). However, the visualizations from the Tableau workbook can be produced by the csvs in the MinifigData file.


Necessary technologies for obtaining data and running SQLite code: **SQLite3 version 3.32.1 or newer and Ubuntu/Linux**. Powershell also may be used, but the Makefile will not work so files should be ran separately. If using Powershell, run the files in the same order they are ran in the "make build" command in the Makefile.


*To check if your version is up to date, run "sqlite3 --version" in the command line*

If you want to download all of the csv files and import all of the tables, please go to the ../RebrickableData/ReadME.md file and follow those steps.
Once those steps have been completed, come back to this file.


From the root file, go to the SQLite_Code folder using
- cd SQLite_Code

In the Linux/Ubuntu command line, run
- make all

This should drop all current tables, create the create all of the core tables, import the data from the csvs in the RebrickableData folder, 
create the minifig head data table, derive the categories, and export all of the csvs to the MinifigData folder.