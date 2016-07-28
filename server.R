library(shiny)
library(devtools)
library(ggplot2)
library(hurricaneexposuredata)
library(hurricaneexposure)



shinyServer(function(input, output) {

  
  output$map <-renderPlot({
    a <- map_counties(storm = input$storm_id, metric = input$metric)
    map_tracks(storms = input$storm_id, plot_object = a, plot_points = FALSE) + ### This code runs slower because if we dont change storm_id, only change
     ### Metric, the map_tracks function wont be changed. Indeed, it re-runs map_tracks() so it takes long time to output.
      ggtitle(paste(input$storm_id, input$metric, sep = ", "))
                     
    })
  

})