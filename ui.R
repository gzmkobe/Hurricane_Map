library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hurricane"),
  

  sidebarLayout(
    sidebarPanel(
      selectInput("year",label = "year",
                  choices= c("1999"="1999"),
                  selected = "1999"),
        
      
      
      selectInput("storm_id",label="storm_id",
                  c("Floyd-1999"),
        
      
      
      selectInput("metric", label="metric",
                 choices =  c("distance","rainfall","wind"),
                 selected = "distance")
      
      
                 ),
    
    mainPanel(plotOutput("map"))
  )
))