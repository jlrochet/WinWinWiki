## Jean-Louis Rochet, 8-4-16
## Leaflet visualization for MA WinWin Wiki

# Load libraries
library(magrittr)
library(dplyr)
library(readr)
library(leaflet)

# Set working directory
setwd("/Users/JLR/Documents/GitHub Repos/WinWin")

# Read file
wiki <- read_csv("mawiki.csv")

# Clean up file (remove duplicate and unnecessary columns, etc.)
wiki <- wiki[ , !duplicated(colnames(wiki))]
wiki %>%
        select(Organization, Website, Sector, Dimension = `Primary Dimension`, 
               Component = `Primary Componenet`, Indicator = `Primary Indicator`, 
               Resources = `Budget/Revenue`, Latitude, Longitude) -> wikitable

# Remove rows without Resources
wikitable <- wikitable[!(is.na(wikitable$Resources) | wikitable$Resources==0),]

# Convert Sector to factor
wikitable$Sector <- as.factor(wikitable$Sector)

# Define sector colors
pal <- colorFactor(c("navy", "red", "green"), domain = c("Public", "Social", "Private"))

# Create leaflet widget with clusters
m <- leaflet(data = wikitable) %>%
        addTiles() %>%
        addCircleMarkers(popup = ~Organization, color = ~pal(Sector), 
                         clusterOptions = markerClusterOptions())

# Output leaflet widget
m
                
# Host on shiny (?)