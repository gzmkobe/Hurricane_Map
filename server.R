library(shiny)
library(devtools)
library(hurricaneexposuredata)
library(hurricaneexposure)



shinyServer(function(input, output) {
  
  output$map <-renderPlot({
    args1 <- swtich (input$storm_id, "Floyd-1999" = "Floyd-1999") 
    args2 <- switch (input$metric, 
                     "distance" ="distance",
                     "rainfall"="rainfall",
                     "wind"="wind")
    map_counties(args1,args2)
                     
    })
  
})