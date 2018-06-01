# =====================================================================================================================
# = Data from an API                                                                                                  =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# It's often not necessary to interact directly with an API (there are many packages which facilitate the interaction!)
# but it's very handy to know how to do it if necessary.
#
# Here are some packages which wrap various APIs:
#
# - Quandl
# - rtweet
# - Rlinkedin
# - instaR
# - gmailr
# - rdrop2 (Dropbox)

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL_BEERS = "https://api.punkapi.com/v2/beers/"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(dplyr)
library(jsonlite)
library(httr)
library(RCurl)
library(Quandl)

# A NOTE ON JSON ------------------------------------------------------------------------------------------------------

# JSON has six basic data types:
#   
# * number (either an integer or a floating point number);
# * string (Unicode characters enclosed by double quotation marks);
# * Boolean (true or false);
# * array (a sequence of items separated by commas and enclosed in square brackets);
# * object (a sequence of key/value pairs separated by commas and enclosed in curly brackets);
# * null.

# A sample JSON document:
#
# [
#   {
#     "id": 1,
#     "name": "John",
#     "surname": "Smith",
#     "email": "me@johnsmith.com",
#     "gender": "M"
#   }, {
#     "id": 2,
#     "name": "Prince",
#     "surname": null,
#     "email": "prince@purple-rain.com",
#     "gender": "M"
#   }
# ]

# GET A BUZZ ON -------------------------------------------------------------------------------------------------------

# Complete the URL by providing a "end point".
#
url_buzz = paste0(URL_BEERS, "1")

# There are a number of ways that we can access that URL.

# METHOD #1
#
# Just open a connection to the URL.
#
(buzz <- readLines(url_buzz))

# METHOD #2
#
# Use getURL() from the RCurl package.
#
(buzz  <- getURL(url_buzz))
#
# What is the format of the result?

# METHOD #3
#
# Use GET() from the httr package.
#
buzz <- GET(url_buzz)
#
# Check response status.
#
http_status(buzz)
buzz$status_code
#
# Response as raw JSON.
#
content(buzz, as = "text", encoding = "UTF-8")
#
# Reponse parsed into a list.
#
content(buzz)
content(buzz)[[1]]$name

# Q. Get the name and tag line of the first ten beers on the API.

# GET WITH AUTHENTICATION ---------------------------------------------------------------------------------------------

# Sign up at www.quandl.com and get yourself an API key. Enter the key below.
#
QUANDLKEY = NA

# Q. Retrieve the WIKI/FB data as a JSON document. You'll need a URL that looks something like this:
#
#      https://www.quandl.com/api/v3/datasets/WIKI/FB.json?api_key=QH2odbmPdS3piCMSWNfJ
#
#    - First do this directly in your browser.
#    - Now retrieve the data with R.

# USING A PACKAGE -----------------------------------------------------------------------------------------------------

Quandl.api_key(QUANDLKEY)

# Daily data.
#
Quandl("WIKI/FB")

# Monthly data with specified start date.
#
Quandl("WIKI/FB", collapse = "monthly", start_date = "2013-01-01")

# EXERCISES -----------------------------------------------------------------------------------------------------------

# SOLUTION: BEERS -----------------------------------------------------------------------------------------------------

lapply(1:10, function(n) {
  url = paste0(URL_BEERS, n)
  
  beer <- GET(url) %>% content() %>% .[[1]]
  #
  tibble(
    name = beer$name,
    tagline = beer$tagline
  )
}) %>% bind_rows()

# SOLUTION: FACEBOOK --------------------------------------------------------------------------------------------------

url = sprintf("https://www.quandl.com/api/v3/datasets/WIKI/FB.json?api_key=%s", QUANDLKEY)

facebook <- GET(url)
#
# Check status of HTTP request.
#
http_status(facebook)
#
# Look at the JSON contents of the response.
#
content(facebook, as = "text")
#
# Parse the JSON.
#
facebook <- fromJSON(content(facebook, as = "text"))
#
names(facebook$dataset)
#
facebook.data <- data.frame(facebook$dataset$data, stringsAsFactors = FALSE)
colnames(facebook.data) <- gsub("[\\. -]", "", facebook$dataset$column_names)
#
facebook.data = facebook.data %>% mutate(
  Date = as.Date(Date),
  AdjClose = as.numeric(AdjClose)
)