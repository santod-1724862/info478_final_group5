library(leaflet)
library(dplyr)
library(tidyr)
library(stringr)
# Get motor vehicle data
motor_vehicle_death <-
  read.csv("Data/motor_vehicle_death.csv") %>% na_if("") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>% drop_na(state) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  ) %>% rename(name = state)

motor_vehicle_death_gender <- motor_vehicle_death %>%
  filter(type == "male" | type == "female")
motor_vehicle_death_age <- motor_vehicle_death %>%
  filter(str_detect(type, "age_")) %>%
  mutate(type = gsub("age_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
motor_vehicle_death_all <- motor_vehicle_death %>%
  filter(type == "all_ages") %>% select(-type)


# Get impaired driving data
impaired_driving_death <-
  read.csv("Data/impaired_driving_death.csv") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  ) %>% rename(name=state)

impaired_driving_death_gender <- impaired_driving_death %>%
  filter(type == "male" | type == "female")
impaired_driving_death_age <- impaired_driving_death %>%
  filter(str_detect(type, "ages_")) %>%
  mutate(type = gsub("ages_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
impaired_driving_death_all <- impaired_driving_death %>%
  filter(type == "all_ages") %>% select(-type)

# From http://leafletjs.com/examples/choropleth/us-states.js
states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")

get_map_data <- function(input){
  if(input$map_type == "dd"){
    return(motor_vehicle_death_all %>% filter(year == input$map_year))
  }else if(input$map_type == "idd"){
    return(impaired_driving_death_all %>% filter(year == input$map_year))
  }else{
    md <- motor_vehicle_death_all %>% filter(year == input$map_year) %>% rename(vehicle_death = value) 
    idd <- impaired_driving_death_all %>% filter(year == input$map_year) %>% rename(impaired_death = value)
    res <- merge(md, idd, by=c("name")) %>% mutate(value = round(100 * impaired_death / vehicle_death), 1)
    return(res)
  }
}

bins <- list(dd = 6,
             idd = 6,
             ratio = c(20, 30, 40, 50, 60, 70, 100))
labels <- list(dd = "<strong>%s</strong><br/>%g deaths per 100,000", 
               idd = "<strong>%s</strong><br/>%g deaths per 100,000", 
               ratio = "<strong>%s</strong><br/>%g%% total deaths")
map_function <- function(input, output){
  output$heatmap <- renderLeaflet({
    a_type <- input$map_type
   
    selected_map_data <-  get_map_data(input)
    map_data <- sp::merge(states, selected_map_data, by="name")
    pal <- colorBin("plasma", domain = map_data$value, bins = bins[[input$map_type]])
    
    labels <- sprintf(
      labels[[input$map_type]],
      map_data$name, map_data$value
    ) %>% lapply(htmltools::HTML)
    
    leaflet(map_data) %>%
      setView(-96, 37.8, 4) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(value),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
    
  })
  output$heatmap_table <- renderDataTable({
    (get_map_data(input) %>% select(-location, -year) %>% arrange(value))
  })
}