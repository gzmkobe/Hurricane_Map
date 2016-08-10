library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)
library(ggplot2)

data("hurr_tracks")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]


shinyUI(fluidPage(
  
  # Application title
  titlePanel("County-level exposure to tropical storms"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", label = "Storm year", years,
                  selected = "1988"),
      
      # This outputs the dynamic UI component
      uiOutput("ui"),
      selectInput("metric", label="Storm exposure metric:",
                  choices =  c("distance", "rainfall", "wind"),
                  selected = "distance"),
      numericInput("limit", 
                   label = "Limit range", 
                   value = 100),
      downloadButton('downloadData', 'Download The Table')
      
    ),
    mainPanel(plotOutput("map"))
  ),
  fluidRow(
    DT::dataTableOutput("table")
  )
  
))