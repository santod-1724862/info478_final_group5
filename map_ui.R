library(leaflet)

map_page <- tabPanel(
  "Interactive Map",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "map_type",
        label = "Map Type",
        choices = c("Education", "Diversity", "Poverty")
      ),
      selectInput(
        inputId = "map_year",
        label = "Year",
        choices = c("2014", "2012")
      )
    ),
    mainPanel(
      h3("Statistics of the Midwest States"),
      p("A map of various statistics of counties and states in the midwest, 
        including education, poverty and diversity. ",
        strong("Marker sizes are based on the amount of 
        education/diversity/poverty per county/state. 
        For counties, opacity also depends on this.")),
      leafletOutput("heatmap"),
    )
  )
)