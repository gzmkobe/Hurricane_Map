library(shiny)
library(ggplot2)
library(hurricaneexposure)

shinyServer(function(input, output) {

  output$mapPlot <- renderPlot({
    a <- map_counties(storm = input$storm_id, metric = input$metric)
    map_tracks(storms = input$storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_id, input$metric, sep = ", "))
  })
})