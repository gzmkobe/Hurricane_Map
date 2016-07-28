library(shiny)
<<<<<<< HEAD
library(devtools)
library(ggplot2)
library(hurricaneexposuredata)
=======
library(ggplot2)
>>>>>>> 7aec4718e9af1bd1455ca320f2a068ca2ae22e74
library(hurricaneexposure)



shinyServer(function(input, output) {
<<<<<<< HEAD
  
  output$map <-renderPlot({
    a <- map_counties(storm = input$storm_id, metric = input$metric)
    map_tracks(storms = input$storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_id, input$metric, sep = ", "))
                     
    })
  
=======

  output$mapPlot <- renderPlot({
    a <- map_counties(storm = input$storm_id, metric = input$metric)
    map_tracks(storms = input$storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_id, input$metric, sep = ", "))
  })
>>>>>>> 7aec4718e9af1bd1455ca320f2a068ca2ae22e74
})