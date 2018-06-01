# =====================================================================================================================
# = Flat files                                                                                                        =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL_CSV = "https://rawgit.com/DataWookie/example-data/master/csv/running-race-results.csv"
URL_XLS = "https://rawgit.com/DataWookie/example-data/master/xls/wiki-tickers.xlsx"

CSV_FILENAME = "running-race-results.csv"
XLS_FILENAME = "wiki-tickers.xlsx"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(readr)
library(readxl)
library(writexl)

# FILE SYSTEM INTERACTION ---------------------------------------------------------------------------------------------

getwd()

list.files()

# Create a temporary working directory
#
tempdir()
#
# You can create a named directory with dir.create().

# Change the working directory to the temporary working directory.
#
# This would normally be done directly within RStudio, but it's useful to know how to do it programatically.
#
setwd(tempdir())
getwd()

# SAMPLE DATA ---------------------------------------------------------------------------------------------------------

# Download a sample CSV data from a URL and save a local copy.
#
download.file(URL_CSV, CSV_FILENAME)

# Download a sample XLS data from a URL and save a local copy.
#
download.file(URL_XLS, XLS_FILENAME, mode = "wb")
#
# Note that we need to specify that the contents is binary via the mode argument.

list.files()
#
# Take a look at the contents of these two new files.
#
# Open the CSV file in the terminal using:
#
# $ head running-race-results.csv

# CSV FILES [READ] ----------------------------------------------------------------------------------------------------

# A "delimited file" is one in which fields are separated by a special character. This character is generally one of
# the following:
#
# * comma (",")
# * semi-colon (";")
# * pipe ("|") or
# * white space (space or tab).

# There's a suite of related functions for working with delimited files. Each performs a slightly different variation
# on the same theme.
#
# * read.table()  - white space separator
# * read.csv()    - "," separator; "." for decimal point
# * read.csv2()   - ";" separator; "," for decimal point
# * read.delim()  - tab separator; "." for decimal point
# * read.delim2() - tab separator; "," for decimal point
#
# Important arguments:
#
# - header
# - sep
# - na.strings
# - nrows
# - skip
# - comment.char
# - stringsAsFactors

# Parse the CSV data into a data frame.
#
results <- read.csv(CSV_FILENAME)
#
# Q. Check the resulting data. Is something wrong? Fix it.
#
head(results)

# With read.csv() character columns are converted to factors by default.

# Q. Check column classes and fix.
#
#    - Should time be a factor?
#    - Should date be a factor?
#    - Should name be a factor?

results <- read_csv2(CSV_FILENAME)

# Q. Check column classes and fix.
# Q. Try opening the CSV file directly from the URL.

# CSV FILES [WRITE] ---------------------------------------------------------------------------------------------------

write.table(results, file = "running-race-results.tsv", sep = "\t", row.names = FALSE)
#
# There are other functions in base R for writing flat files:
#
# - write.csv() and
# - write.csv2().

# There are also a set of functions in the readr package:
#
# - write_delim()
# - write_csv() and
# - write_tsv().

# Q. Write the results data to a pipe-delimited file. Pay attention to quoting and row names.

# XLS(X) FILES [READ] -------------------------------------------------------------------------------------------------

wiki <- read_excel(XLS_FILENAME)
#
# The read_excel() function will handle both XLS and XLSX files. There are lower level functions for handling specific
# file types:
#
# - read_xls() and
# - read_xlsx().
#
# This function will not open a file directly from a URL.

# XLS(X) FILES [WRITE] ------------------------------------------------------------------------------------------------

# The write_xlsx() function will write a data frame to a XLSX file.

# RDA / RDS -----------------------------------------------------------------------------------------------------------

# These are not really "flat" file formats, but it makes sense to talk about them now.
#
# By default, when you exit RStudio it will ask you if you want to store the session data. It would store those data in
# a .RData or .rda file. Such a file can capture one or more R objects in binary format.

x <- 3
y <- 5

save(results, x, y, file = "a-few-variables.rda")
saveRDS(x, file = "a-single-variable.rds")

# Remove these variables from the environment.
#
rm(results, x, y)
#
# Verify that they are gone.

# Load single variable (and optionally rename).
#
z <- readRDS("a-single-variable.rds")

# Read one or more variables (with original names).
#
load("a-few-variables.rda")

# CLEANUP -------------------------------------------------------------------------------------------------------------

file.remove("a-few-variables.rda", "a-single-variable.rds")

# EXERCISES -----------------------------------------------------------------------------------------------------------

# 1. Pivot the wiki data into wide format, so that the result has a date column and a column for each of the ticker
#    symbols. Save the resulting data to a XLSX file.