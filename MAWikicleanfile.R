## Jean-Louis Rochet, 8-5-16
## Script just for cleaning up and outputting data file for other uses

# Load libraries
library(magrittr)
library(dplyr)
library(readr)

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

# Write csv
write.csv(wiki, "mawikiclean.csv")