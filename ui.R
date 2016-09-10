library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)
library(ggplot2)


data("hurr_tracks")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]


######################### UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("County-level exposure to tropical storms"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", label = "Storm year", years,
                  selected = "1988"),
      
      # This outputs the dynamic UI component
      uiOutput("stormname"),
      selectInput("metric", label="Storm exposure metric:",
                  choices =  c("distance", "rainfall", "wind"),
                  selected = "distance"),
      uiOutput("metric_input"),
      selectInput("contentSelect", "Select content to display:", choices = c("normal", "flood","tornado"), selected = 1)
      ),
    
    mainPanel(
      uiOutput("content")
      
    )
   )
    
))