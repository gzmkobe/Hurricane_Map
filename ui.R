library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)

data("hurr_tracks")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
<<<<<<< HEAD
years <- years[years<=2011]


=======
years <- years[years <= 2011]
>>>>>>> 734cff36ea4282c4bcdf0a5bc9cf59bef49d45e9

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
                  selected = "distance")
    ),
    mainPanel(plotOutput("map"))
  )
  
))