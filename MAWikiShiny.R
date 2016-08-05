## Jean-Louis Rochet, 8-5-16
## Shiny app for MA WinWin Wiki leaflet map

# Load libraries
library(shiny)
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
               Resources = `Budget/Revenue`, Latitude, Longitude) -> wiki

# Remove rows without Resources
wiki <- wiki[!(is.na(wiki$Resources) | wiki$Resources==0),]

# Convert Sector to factor
wiki$Sector <- as.factor(wiki$Sector)

# Define sector colors
pal <- colorFactor(c("navy", "red", "green"), domain = c("Public", "Social", "Private"))

# ui
ui <- fluidPage(
        leafletOutput("map")
)

#server
server <- function(input, output) {
        output$map <- renderLeaflet({
                leaflet(data = wiki) %>%
                        addTiles() %>%
                        addCircleMarkers(popup = ~Organization, color = ~pal(Sector), 
                                         clusterOptions = markerClusterOptions())
        })
}

# Execute app
shinyApp(ui = ui, server = server)