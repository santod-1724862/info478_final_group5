library(leaflet)

impaired_driving_death <-
  read.csv("Data/impaired_driving_death.csv") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  ) %>% mutate(state = tolower(state))

impaired_driving_death_gender <- impaired_driving_death %>%
  filter(type == "male" | type == "female")
impaired_driving_death_age <- impaired_driving_death %>%
  filter(str_detect(type, "ages_")) %>%
  mutate(type = gsub("ages_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
impaired_driving_death_all <- impaired_driving_death %>%
  filter(type == "all_ages") %>% select(-type)

map_function <- function(input, output){
  output$heatmap <- renderLeaflet({
    a_type <- input$map_type
    # From http://leafletjs.com/examples/choropleth/us-states.js
    states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
    selected_map_data <- impaired_driving_death_all %>% filter(year == input$map_year)
    # bins <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7)
    # pal <- colorBin("YlOrRd", domain = selected_map_data$value, bins = bins)
    bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
    pal <- colorBin("YlOrRd", domain = states$density, bins = bins)

    labels <- sprintf(
      "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
      states$name, states$density
    ) %>% lapply(htmltools::HTML)
    
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(density),
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
    
    
    
    # leaflet(data = selected_map_data) %>%
    # addTiles() %>%
    #   addPolygons(
    #     fillColor = ~pal(density),
    #     weight = 2,
    #     opacity = 1,
    #     color = "white",
    #     dashArray = "3",
    #     fillOpacity = 0.7,
    #     highlightOptions = highlightOptions(
    #       weight = 5,
    #       color = "#666",
    #       dashArray = "",
    #       fillOpacity = 0.7,
    #       bringToFront = TRUE))
    
  })
}