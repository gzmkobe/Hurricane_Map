library(shiny)
library(devtools)
library(hurricaneexposuredata)
library(hurricaneexposure)

shinyServer(function(input, output) {
  
  output$mapPlot <- map_counties(input$Floyd-1999, input$metric = "metric")
})