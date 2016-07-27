library(shiny)
data("hurr_tracks")
storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hurricane"),
  
  sidebarLayout(
    sidebarPanel(
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
                 ),
    
    mainPanel(
      plotOutput("mapPlot")
              )
  )
))