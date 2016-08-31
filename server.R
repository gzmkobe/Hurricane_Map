library(shiny)
library(devtools)
library(ggplot2)
library(hurricaneexposuredata)
library(hurricaneexposure)
library(choroplethrMaps)
library(dplyr)
library(purrr)

data("hurr_tracks")
data("county_centers")

storms <- unique(hurr_tracks$storm_id)
storm_years <- as.numeric(gsub(".+-", "", storms))
storms <- storms[storm_years <= 2011]

years <- unique(storm_years)
years <- years[years <= 2011]


all_fips <- unique(county_centers$fips)

## Split storm_id based on same year
stm <- split(storms, gsub(".+-", "", storms))
stm <- lapply(stm, function (x) gsub("-.+", "", x))

### Define global variable outside of Shinys
tab_out <- NULL


shinyServer(function(input, output, session) {
  
  output$stormname <- renderUI({
    
    selectInput("storm_name", label = "Storm name", stm[input$year],
                selected = "Alberto")
    
  }) 
  
  output$metric_input <- renderUI({
    if(input$metric=="distance"){
      numericInput(inputId = paste0("dist_limit"),paste0("dist_limit"),100)
    }else if( input$metric=="rainfall"){
      list(   ### use list to and ui() to make achieve when select rainfall, three limits appears
        numericInput(inputId = paste0("rain_limit"),paste0("rain_limit"),100),
        numericInput(inputId = paste0("dist_limit"),paste0("dist_limit"),500),
        sliderInput(inputId = paste0("days_included"),paste0("days_included"),
                    min=-3,max=3,value=c(-2,1))
        
        
      )
    }else if (input$metric=="wind"){
      numericInput(inputId = paste0("wind_limit"),paste0("wind_limit"),100)
    }
    
  })
  
  # First tab
  output$map <-renderPlot({
    storm_id <- paste(input$storm_name, input$year, sep = "-")
    a <- map_counties(storm = storm_id, metric = input$metric)
    map_tracks(storms = storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_name, input$year, input$metric, sep = ", "))+
      theme(plot.title = element_text(margin = margin(t = 10, b = -20)))  ### adjust title position
    
  })
  
  # Second tab
  output$table <- DT::renderDataTable(DT::datatable({
   if(input$metric == "distance"){
     tab_out <<- county_distance(counties = all_fips, start_year = input$year, 
                     end_year = input$year, dist_limit = input$dist_limit) %>%
       dplyr::filter(storm_id == paste(input$storm_name,
                                       input$year, sep = "-")) %>%
       dplyr::left_join(county_centers, by = "fips") %>%
       dplyr::mutate(county = paste(county_name, state_name, sep =  ", ")) %>%
       dplyr::select(county, fips, closest_date, storm_dist) %>%
       arrange(storm_dist)
   } else if (input$metric == "rainfall"){
     tab_out <<- county_rain(counties = all_fips, start_year = input$year, 
                            end_year = input$year, rain_limit = input$rain_limit,dist_limit = input$dist_limit,
                            days_included=input$days_included[1]:input$days_included[2]) %>%   
       ### The function below takes day_included=c(-2,-1,0,1) so we need a seq to let the function work 
       dplyr::filter(storm_id == paste(input$storm_name,
                                       input$year, sep = "-")) %>%
       dplyr::left_join(county_centers, by = "fips") %>%
       dplyr::mutate(county = paste(county_name, state_name, sep =  ", ")) %>%
       dplyr::select(county, fips, closest_date, tot_precip) %>%
       dplyr::rename(rainfall_mm = tot_precip) %>%
       arrange(desc(rainfall_mm))
   } else if(input$metric == "wind"){
     tab_out <<- county_wind(counties = all_fips, start_year = input$year, 
                                end_year = input$year, wind_limit = input$wind_limit) %>%
       dplyr::filter(storm_id == paste(input$storm_name,
                                       input$year, sep = "-")) %>%
       dplyr::left_join(county_centers, by = "fips") %>%
       dplyr::mutate(county = paste(county_name, state_name, sep =  ", ")) %>%
       dplyr::select(county, fips, max_sust) %>%
       dplyr::rename(wind_mps = max_sust) %>%
       arrange(desc(wind_mps))
   }
  })
  )
  
  #Third tab
  output$exp <- renderPlot({
    storm_id <- paste(input$storm_name, input$year, sep = "-")
  
    
    if(input$metric == "distance"){
      b <- map_distance_exposure(storm = storm_id,dist_limit = input$dist_limit)
    } else if (input$metric == "rainfall"){
      b <- map_rain_exposure(storm = storm_id,rain_limit = input$rain_limit,dist_limit = input$dist_limit,
                             days_included=input$days_included[1]:input$days_included[2])
    } else if (input$metric == "wind"){
      b <- map_wind_exposure(storm = storm_id,wind_limit = input$wind_limit)
    }
    map_tracks(storms = storm_id, plot_object = b, plot_points = FALSE) + 
      ggtitle(paste(input$storm_name, input$year, input$metric, input$limit, sep = ", "))+theme(plot.title = element_text(margin = margin(t = 10, b = -20)))
  })
  
  # Fourth tab
  output$map1 <-renderPlot({
    storm_id <- paste(input$storm_name, input$year, sep = "-")
    a <- map_event_exposure(storm = storm_id, event_type = input$contentSelect)
    map_tracks(storms = storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_name, input$year, input$contentSelect, sep = ", "))+
      theme(plot.title = element_text(margin = margin(t = 10, b = -20)))  ### adjust title position
    
  })
  
  # Fifth tab
  output$table1 <- DT::renderDataTable(DT::datatable({
    c <- county_events(counties = all_fips,
                  start_year = input$year, end_year = input$year,
                  event_type = input$contentSelect)
    
  }))
  
  ## 
  observeEvent(input$contentSelect, {
    if (input$contentSelect == "normal") {
      output$content <- renderUI({
        tabsetPanel(
          tabPanel("Map_Counties",plotOutput("map")),
          tabPanel("Table",DT::dataTableOutput("table"),downloadButton('downloadData', 'Download The Table')),  ### make download button inside table tab
          tabPanel("Map_Exposure",plotOutput("exp"))
        )
      })    
    } else {
      output$content <- renderUI({
        tabsetPanel(type = "tabs",
                    tabPanel("map_event_exposure", plotOutput("map1")),
                    tabPanel("county_events",DT::dataTableOutput("table1"))
        )
      })       
    }
  })
  output$downloadData <- downloadHandler(
    filename = function() {paste(input$storm_name, input$year, input$metric, input$limit, '.csv', sep='')},
    content = function(file) {
      write.csv(tab_out, file)
    })
  
})