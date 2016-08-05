library(shiny)
library(devtools)
library(ggplot2)
library(hurricaneexposuredata)
library(hurricaneexposure)


data("hurr_tracks")
storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]

## Split storm_id based on same year
stm <- split(storms, gsub(".+-", "", storms))

shinyServer(function(input, output,session) {
  
  output$ui <- renderUI({
    
    selectInput("storm_id", label = "storm_id", stm[input$years])
    
  }) 
  
  output$map <-renderPlot({
    a <- map_counties(storm = input$storm_id, metric = input$metric)
    map_tracks(storms = input$storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_id, input$metric, sep = ", "))
    
  })
  
})