library(shiny)
<<<<<<< HEAD
library(hurricaneexposure)
library(hurricaneexposuredata)
data("hurr_tracks")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

=======
data("hurr_tracks")
storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]
>>>>>>> 7aec4718e9af1bd1455ca320f2a068ca2ae22e74

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hurricane"),
  
  sidebarLayout(
    sidebarPanel(
<<<<<<< HEAD
      
      selectInput("storm_id",label="storm_id",
                  storms
                  ),
      
      selectInput("metric", label="Storm Exposure Metric:",
                 choices =  c("distance","rainfall","wind"),
                 selected = "distance")
=======
      # selectInput("year",label = "year",
      #             c("1999"="1999")
      # 
      # ),

      selectInput("storm_id",label="storm_id",
                  storms
      ),

      selectInput("metric", label="Storm exposure metric:",
                  c("distance" = "distance",
                    "rainfall" = "rainfall",
                    "wind" = "wind"))
>>>>>>> 7aec4718e9af1bd1455ca320f2a068ca2ae22e74
                 ),
    
    mainPanel(plotOutput("map")))

))