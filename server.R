library(shiny)
library(devtools)
library(ggplot2)
library(hurricaneexposuredata)
library(hurricaneexposure)
library(choroplethrMaps)
library(dplyr)

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

### Define global variable outside of shinyse
tab_out <- NULL


shinyServer(function(input, output, session) {
  
  output$ui <- renderUI({
    
    selectInput("storm_name", label = "Storm name", stm[input$year],
                selected = "Alberto")
    
  }) 
  
  output$map <-renderPlot({
    storm_id <- paste(input$storm_name, input$year, sep = "-")
    a <- map_counties(storm = storm_id, metric = input$metric)
    map_tracks(storms = storm_id, plot_object = a, plot_points = FALSE) + 
      ggtitle(paste(input$storm_name, input$year, input$metric, sep = ", "))
    
  })
  
  
  output$table <- DT::renderDataTable(DT::datatable({
   if(input$metric == "distance"){
     tab_out <<- county_distance(counties = all_fips, start_year = input$year, 
                     end_year = input$year, dist_limit = input$limit) %>%
       dplyr::filter(storm_id == paste(input$storm_name,
                                       input$year, sep = "-")) %>%
      dplyr::left_join(county_centers, by = "fips") %>%
       dplyr::mutate(county = paste(county_name, state_name, sep =  ", ")) %>%
       dplyr::select(county, fips, closest_date, storm_dist) %>%
       arrange(storm_dist)
   } else if (input$metric == "rainfall"){
     tab_out <<- county_rain(counties = all_fips, start_year = input$year, 
                            end_year = input$year, rain_limit = input$limit,dist_limit = 100) %>%
       dplyr::filter(storm_id == paste(input$storm_name,
                                       input$year, sep = "-")) %>%
       dplyr::left_join(county_centers, by = "fips") %>%
       dplyr::mutate(county = paste(county_name, state_name, sep =  ", ")) %>%
       dplyr::select(county, fips, closest_date, tot_precip) %>%
       dplyr::rename(rainfall_mm = tot_precip) %>%
       arrange(desc(rainfall_mm))
   } else if(input$metric == "wind"){
     tab_out <<- county_wind(counties = all_fips, start_year = input$year, 
                                end_year = input$year, wind_limit = input$limit) %>%
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
  
  
  output$exp <- renderPlot({
    storm_id <- paste(input$storm_name, input$year, sep = "-")
  
    
    if(input$metric == "distance"){
      b <- map_distance_exposure(storm = storm_id,dist_limit = input$limit)
    } else if (input$metric == "rainfall"){
      b <- map_rain_exposure(storm = storm_id,rain_limit = input$limit,dist_limit = 100)
    } else if (input$metric == "wind"){
      b <- map_wind_exposure(storm = storm_id,wind_limit = input$limit)
    }
    map_tracks(storms = storm_id, plot_object = b, plot_points = FALSE) + 
      ggtitle(paste(input$storm_name, input$year, input$metric, input$limit, sep = ", "))
  })
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$storm_name, input$year, input$metric, input$limit, 'csv', sep='_') },
    content = function(file) {
      write.csv(tab_out, file)
    })
  
})