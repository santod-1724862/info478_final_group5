library(leaflet)
library(DT)
map_page <- tabPanel(
  "Interactive Map",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "map_type",
        label = "Map Type",
        choices = c("Driving Deaths per 100,000" = "dd", 
                    "Impaired Driving Deaths per 100,000" = "idd", 
                    "Ratio of Impaired Driving Deaths to Total Driving Deaths" = "ratio")
      ),
      selectInput(
        inputId = "map_year",
        label = "Year",
        choices = c("2014", "2012")
      )
    ),
    mainPanel(
      h3("Alcohol and Vehicle Driving Deaths"),
      h4("Map"),
      p(
        "An interactive map visualizing driving deaths and impaired driving deaths in the United States. It was interesting to see that ",
        strong("Hawaii"),
        " has by far the highest percentage of vehicle deaths involving impaired drivers (in both 2012 and 2014). Also note that impaired driving death data for Rhode Island and Vermont are", strong("only available in 2012")
      ), 
      leafletOutput("heatmap"),
      h4("Data"),
      dataTableOutput("heatmap_table")
    )
  )
)