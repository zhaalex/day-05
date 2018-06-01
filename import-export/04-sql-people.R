# =====================================================================================================================
# = SQL from R                                                                                                        =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

library(RMySQL)

db <- dbConnect(RMySQL::MySQL(), dbname = 'people')
#
# You might need to provide more information to connect to your database:
#
# db <- dbConnect(RMySQL::MySQL(), dbname = 'people',
#                 host = 'localhost',
#                 user = "<username>",
#                 password = "<password>")

dbListTables(db)
dbListFields(db, "person")

people <- dbSendQuery(db, "SELECT * FROM person;")

dbFetch(people, n = 2)                # Retrieve first two rows
dbHasCompleted(people)

dbFetch(people, n = -1)               # Retrieve rest of rows
dbHasCompleted(people)

dbClearResult(people)

# Other ways to retrieve these data:
#
dbGetQuery(db, "SELECT * FROM person;")
#
dbReadTable(db, "person")

dbDisconnect(db)
