library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)



data("hurr_tracks")
storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hurricane"),
  
  sidebarLayout(
    sidebarPanel(

      
      selectInput("storm_id",label="storm_id",
                  storms
                  ),
      
      selectInput("metric", label="Storm Exposure Metric:",
                 choices =  c("distance","rainfall","wind"),
                 selected = "distance")

    
                 ),
    
    mainPanel(plotOutput("map")))

))