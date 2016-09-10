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
shinyUI(dashboardPage(skin = "blue",
  
  # Application title
  dashboardHeader(title = "County-level exposure to tropical storms",titleWidth = 400),
  
  dashboardSidebar(valueBox("Description", "This website allows users to create binary hurricane
                            exposure histories for chosen counties in a certain year based on specified thresholds
                            of distance to storm track and rainfall during a the week
                            centered on the storm date. This work was supported in part by grants from
                            the National Institute of Environmental Health Sciences (R00ES022631) and
                            the National Science Foundation (1331399).", color = "black", width = 400),
                   valueBox("User Manual", "Once you select a year, for example, 1998. Then you need to specify the storm name which 
                            was occured in that year. After that, you need to specify the desired exposure metric. 
                            After all the inputs have been specified, the corresponding map(s) and table would be created on the right hand 
                            side. Also, you are allowed to download the table if data is available in it", color = "black", width = 400),
                   width = 400,
                   "For more information, please click the link below",
                   menuItem("Hurricane Exposure", icon = icon("fa fa-github"), 
                            href = "https://github.com/geanders/hurricaneexposure")),
  dashboardBody(
    fluidRow(
      box(
          title = "User Control",status = "warning", solidHeader = TRUE, 
          selectInput("year", label = "Storm year", years,
                      selected = "1988"),
      # This outputs the dynamic UI component
          uiOutput("stormname"),
          selectInput("metric", label="Storm exposure metric:",
                        choices =  c("distance", "rainfall", "wind","flood","tornado"),
                        selected = "distance"),
          uiOutput("metric_input")),
      uiOutput("content")
          
    )
  )
   
    
))