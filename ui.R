library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hurricane"),
  

  sidebarLayout(
    sidebarPanel(
      selectInput("year",label = "year",
                  c("1999"="1999")
        
      ),
      
      selectInput("storm_id",label="storm_id",
                  c("Floyd-1999")
        
      ),
      
      selectInput("metric", label="metric:",
                  c("distance" = "distance",
                    "rainfall" = "rainfall",
                    "wind" = "wind"))
      
      
                 ),
    
    mainPanel(
      plotOutput("mapPlot")
              )
  )
))