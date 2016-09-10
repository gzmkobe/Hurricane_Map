library(shiny)
library(hurricaneexposure)
library(hurricaneexposuredata)
library(ggplot2)
library(shinydashboard)

data("hurr_tracks")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]


######################### UI
shinyUI(dashboardPage(skin = "yellow",
  
  # Application title
  dashboardHeader(title = "County-level Exposure to Tropical Storms",titleWidth = 400),
  
  dashboardSidebar("ffff",
                   width = 400,
                   "For more information, please click the link below",
                   menuItem("Hurricane Exposure", icon = icon("fa fa-github"), 
                            href = "https://github.com/geanders/hurricaneexposure")),
  dashboardBody(
    fluidRow(
      box(
          title = "User Control",status = "primary", solidHeader = TRUE, 
          selectInput("year", label = "Storm year", years,
                      selected = "1988"),
      # This outputs the dynamic UI component
          uiOutput("stormname"),
          selectInput("metric", label="Storm exposure metric:",
                        choices =  c("distance", "rainfall", "wind","flood","tornado"),
                        selected = "distance"),
          uiOutput("metric_input")),
      box(uiOutput("content")
          )
    )
  )
   
    
))