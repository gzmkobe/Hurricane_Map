library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)


data("hurr_tracks")
storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]

## Split storm_id based on same year
stm <- split(storms, gsub(".+-", "", storms))


shinyUI(fluidPage(
  
  # Application title
  titlePanel("County-level exposure to tropical storms"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", label = "Storm year", years),
      
      # This outputs the dynamic UI component
      uiOutput("ui"),
      selectInput("metric", label="Storm exposure metric:",
                  choices =  c("distance", "rainfall", "wind"),
                  selected = "distance")
    ),
    mainPanel(plotOutput("map"))
  )
  
))