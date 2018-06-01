# =====================================================================================================================
# = ggplot2: Quick Introduction                                                                                       =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# References:
#
# ggplot2 Documentation: http://ggplot2.tidyverse.org/reference/

# CONFIGURATION -------------------------------------------------------------------------------------------------------

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(ggplot2)

# SAMPLE DATA ---------------------------------------------------------------------------------------------------------

# We'll be using the diamonds data set from the ggplot2 package. It's got a lot of rows and to speed things up we're
# going to randomly sample a subset of those rows.
#
diamonds = diamonds[sample(1:nrow(diamonds), 10000),]

# BASE GRAPHICS -------------------------------------------------------------------------------------------------------

head(diamonds)

plot(price ~ carat, data = diamonds, pch = 19, xlab = "Carat", ylab = "Price")
#
# See ?plot.default for more details.

hist(diamonds$price, main = "Diamond Price", xlab = "Price (USD)", ylab = "Count", col = "#f47b5d")

boxplot(price ~ cut, data = diamonds, outline = FALSE, col = "#f47b5d")

# THE GRAMMAR OF GRAPHICS ---------------------------------------------------------------------------------------------

# ggplot2 is based on the principles of the "Grammar of Graphics".
#
# Wilkinson, L. (2005). The Grammar of Graphics. New York: Springer-Verlag.

# A graph is built up of a number of components:
#
# - data
# - geometric objects
# - aesthetic mappings
# - scales
# - coordinate systems
# - facets.

# GEOMS AND AESTHETICS ------------------------------------------------------------------------------------------------

# Create underlying plot object.
#
fig <- ggplot(diamonds, aes(x = carat, y = price))

# Add in a point geom (scatterplot).
#
fig + geom_point()
#
# See ?geom_point.

# Change colour of points.
#
fig + geom_point(colour = "blue")

# There's a lot of overplotting, so let's make the points transparent.
#
fig + geom_point(colour = "blue", alpha = 0.25)

# Use aesthetic to color points.
#
(fig <- fig + geom_point(aes(colour = cut), alpha = 0.25, size = 2))

# Choose a different colour scale.
#
fig + scale_colour_brewer(palette = "Greens")
#
# This scale uses palettes from http://colorbrewer2.org/.

# HISTOGRAM -----------------------------------------------------------------------------------------------------------

fig <- ggplot(diamonds, aes(x = price))

# A default histogram.
#
fig + geom_histogram()
#
# See ?geom_histogram.

# Set the bin width.
#
fig + geom_histogram(binwidth = 500)

# Use aesthetic for fill.
#
(fig <- fig + geom_histogram(aes(fill = clarity), binwidth = 500))

# Is clarity an ordered factor?
#
class(diamonds$clarity)
#
# So we can choose a better colour scale.
#
(fig <- fig + scale_fill_brewer(palette = "PuBuGn"))
#
# Note that we are using scale_fill_brewer() rather than scale_colour_brewer().

# Change axis labels and theme.
#
fig + labs(x = "Price [USD]", y = "Count") + theme_classic()

# FACETING ------------------------------------------------------------------------------------------------------------

(fig <- ggplot(diamonds, aes(x = carat, y = price)) +
   geom_point() +
   labs(x = "Carat", y = "Price [USD]"))

# Split into multiple panels by colour.
#
fig + facet_wrap(~ color)

# Split into multiple panels by colour and cut.
#
fig + facet_grid(cut ~ color)

# THEMES --------------------------------------------------------------------------------------------------------------

# You can globally change the default theme.
#
theme_set(theme_minimal())

# EXERCISES -----------------------------------------------------------------------------------------------------------

# We'll be using the baseball data from the corrgram package.

# Exercise 1 ----------------------------------------------------------------------------------------------------------

# We'll start off using plotting capabilities from base R.

# 1. Install corrgram if necessary.
# 2. Load the library.
# 3. Get acquainted with the baseball data.
# 4. Make a scatter plot showing logSal against Years.
#     - Label axes appropriately. Add a plot title.
#     - Use the col parameter to add a splash of colour.
#     - Change the plotting symbol. Search for "pch" on ?par.
# 5. Generate a pairs plot for the variables `Atbat`, `Hits`, `Homer`, `Runs`, `RBI`, `Walks` and `Years`.
#     - Which of these features are most obviously correlated?

# Exercise 2 ----------------------------------------------------------------------------------------------------------

# 1. Make a box plot of logSal versus Position. Conclusions?
# 2. Make a mosaic plot which shows the distribution of Position versus Team.
#     - See ?spineplot for details of the plot() method.
#     - Create a mosaic plot for Position versus League.

# Exercise 3 ----------------------------------------------------------------------------------------------------------

# 1. Create a histogram for logSal.
#     - Change the bin width to 0.25.
#     - Use a colour to fill the histogram.
#     - Convert from counts to density.

# Exercise 4 ----------------------------------------------------------------------------------------------------------

# Load ggplot2 and use it for the following exercises.

# 1. Make a scatter plot showing logSal against Years.
#     - Colour points by Position. Would this be possible with base graphics? Would it be easy?
#     - Deal with overplotting.
#     - Change the plot theme. I like the classic theme, but you should find something that works for you.
#     - Install ggthemes and explore a wider range of themes.
#     - Add a smoothed curve to the data.
#     - Try a different color palette. See http://colorbrewer2.org/.
#     - Add a 2D density estimate.

# Exercise 5 ----------------------------------------------------------------------------------------------------------

# 1. Make a histogram of logSal.
#     - Sort out any warning messages.
#     - Create overlays for each Position.
#     - Split the plot into facets.
#     - Add apropriate labels for axes. Add a plot title.
# 2. Create a smoothed density estimate with the same data.
#     - Create overlays for each Position.

# Exercise 6 ----------------------------------------------------------------------------------------------------------

# Produce a visualisation like http://www.economist.com/blogs/graphicdetail/2017/04/daily-chart-3.
#
#     a) Find appropriate data.
#     b) Transform data into a suitable format.
#     c) Construct the visualisation.

# EXERCISE SOLUTIONS --------------------------------------------------------------------------------------------------

# Exercise 1 ----------------------------------------------------------------------------------------------------------

library(corrgram)

plot(logSal ~ Years, data = baseball, xlab = "Years of Play", ylab = "Logarithm of Salary", col = "red", pch = 19)

plot(baseball[, 5:11])

# Exercise 2 ----------------------------------------------------------------------------------------------------------

plot(logSal ~ Position, data = baseball)

plot(Position ~ Team, data = baseball)
mosaicplot(League ~ Position, data = baseball, main = "Mosaic: Position verus League")

# Exercise 3 ----------------------------------------------------------------------------------------------------------

hist(baseball$logSal)
hist(baseball$logSal, breaks = seq(1.75, 3.5, 0.25))
hist(baseball$logSal, breaks = seq(1.75, 3.5, 0.25), col = "lightgreen")
hist(baseball$logSal, breaks = seq(1.75, 3.5, 0.25), col = "lightgreen", probability = TRUE)

# Exercise 4 ----------------------------------------------------------------------------------------------------------

library(ggplot2)

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point()

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position))

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position), alpha = 0.5, position = "jitter")

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position), alpha = 0.5, position = "jitter") +
  theme_classic()

library(ggthemes)

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position), alpha = 0.5, position = "jitter") +
  theme_wsj()

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position), alpha = 0.5, position = "jitter") +
  geom_smooth() + scale_colour_brewer(palette = "Set1") +
  theme_classic()

ggplot(baseball, aes(x = Years, y = logSal)) +
  geom_point(aes(col = Position), alpha = 0.5, position = "jitter") +
  geom_density_2d(colour = "darkgrey") +
  geom_smooth() + scale_colour_brewer(palette = "Set1") +
  theme_classic()

# Exercise 5 ----------------------------------------------------------------------------------------------------------

ggplot(baseball, aes(x = logSal)) +
  geom_histogram(binwidth = 0.125) +
  theme_classic()

# Stacked version
#
ggplot(baseball, aes(x = logSal)) +
  geom_histogram(aes(fill = Position), binwidth = 0.125) +
  theme_classic()

ggplot(baseball, aes(x = logSal)) +
  geom_histogram(aes(fill = Position), binwidth = 0.125, alpha = 0.55, position = "identity") +
  theme_classic()

ggplot(baseball, aes(x = logSal)) +
  geom_histogram(aes(fill = Position), binwidth = 0.125, alpha = 0.55) +
  facet_grid(Position ~ .) +
  labs(x = "Logrithm of Salary", y = "Count") +
  ggtitle("Salary Distribution by Position") +
  theme_classic()

ggplot(baseball, aes(x = logSal)) +
  geom_density(aes(fill = Position), color = "black", alpha = 0.5) +
  scale_fill_brewer(palette = "Set1") +
  theme_classic()

# Exercise 6 ----------------------------------------------------------------------------------------------------------

# Code to emulate this plot:
#
# http://cdn.static-economist.com/sites/default/files/imagecache/1872-width/20170415_WOC921.png

# Grab data.
#
smoking <- read.csv("https://raw.githubusercontent.com/DataWookie/example-data/master/csv/who-smoking-data.csv", comment.char = "#")

# Transform to tidy format.
#
library(tidyr)
#
smoking <- gather(smoking, gender, percent, Male, Female)

# Transform percent column (dropping confidence interval).
#
library(dplyr)
#
smoking <- mutate(smoking,
                  percent = as.numeric(sub(" \\[.*\\]$", "", percent))
)

# We'll focus on the change between 2005 and 2015. Also remove records with missing percent.
#
smoking <- filter(smoking, Year == 2005 | Year == 2015, !is.na(percent))

# Sort more conveniently.
#
smoking <- arrange(smoking, Country, gender, Year)

# Filter out countries which don't have data for both sexes and years.
#
smoking <- group_by(smoking, Country) %>%
  mutate(count = n()) %>%
  filter(count == 4) %>%
  select(-count) %>%
  ungroup()

# Transform Year data so that it can be used for columns.
#
smoking <- mutate(smoking, Year = paste0("Y", Year))

# Pivot the data so that we have columns for each year.
#
smoking <- spread(smoking, Year, percent)

# Calculate percent change.
#
smoking <- mutate(smoking, change = Y2015 - Y2005) %>%
  select(-starts_with("Y"))

# Pivot one last time.
#
smoking <- spread(smoking, gender, change)

# Add column for colours.
#
PALETTE = c("#90524e", "#00a0d1", "#8cd7f8", "#f47b5d")
#
smoking <- mutate(smoking,
                  quadrant = ifelse(
                    Male > 0,
                    ifelse(Female > 0, 1, 4),
                    ifelse(Female > 0, 2, 3)
                  ),
                  quadrant = factor(quadrant, labels = PALETTE)
)

library(ggplot2)

fig <- ggplot(smoking, aes(x = Male, y = Female))

# Add in points.
#
fig + geom_point()
fig + geom_point(size = 3, alpha = 0.5)

# Sort out point colour.
#
(fig <- fig + geom_point(aes(colour = quadrant), size = 3, alpha = 0.65) +
    scale_colour_manual(values = PALETTE))

# Add in zero lines.
#
(fig <- fig + geom_hline(yintercept = 0, lty = "dashed") + geom_vline(xintercept = 0, lty = "dashed"))

# Change axis labels.
#
(fig <- fig + labs(x = "Change in male rate", y = "Change in female rate"))

# Tweak the theme.
#
(fig <- fig + theme_minimal() +
    theme(axis.title = element_text(face = "italic"),
          legend.position = "none"))

# Label points.
#
library(ggrepel)
#
LABELS = c("Belarus", "Sweden", "Canada", "Japan", "Turkey", "Chile", "Nepal", "Norway", "Denmark",
           "Jordan", "Bahrain", "Lebanon",
           "Mauritania", "Sierra Leone", "Indonesia", "Pakistan",
           "Russian Federation", "Lithuania", "Croatia")
#
smoking <- mutate(smoking,
                  label = ifelse(Country %in% LABELS, as.character(Country), NA)
)
#
fig + geom_text_repel(data = smoking, aes(label = label), force = 15)
