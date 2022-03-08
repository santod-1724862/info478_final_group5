
#install packages
library(shiny)
library(ggplot2)
library(plotly)

# source pages
source("map_ui.R")
# read dataset 


# --------- CREATE WIDGETS ---------- 

# choose county widget (this widget allows you to 
# choose which county you want to have the plot focus on)




# enrollment size widget (this widget allows you to choose the
# range of enrollment size)



# --------- CREATE PAGES ---------- 

page_one <- tabPanel(
  "Page 1",                   #title of the page, what will appear as the tab name
  sidebarLayout(             
    sidebarPanel( 
      # left side of the page 
      # insert widgets or text here -- their variable name(s), NOT the raw code
    ),           
    mainPanel(                # typically where you place your plots + texts
      # insert chart and/or text here -- the variable name NOT the code
    )))


# age data

age_data <- read_csv("Data/gbd_death_dalys.csv")

age_data <- age_data %>%
  select(-c(location_id, sex_id, age_id, cause_id, metric_id))

age_data <- age_data[order(age_data$location_name),]

names(age_data)[names(age_data) == 'DALYs (Disability-Adjusted Life Years)'] <- 'DALYs'

# age page widgets

state_input <- selectInput(
  "state",
  label = h3("State"),
  choices = unique(age_data$location_name)
)

years_input <- checkboxGroupInput(
  "years",
  label = h3("Years"),
  choices = c("2016" = 2016,
              "2017" = 2017,
              "2018" = 2018,
              "2019" = 2019),
  selected = c(2016, 2017, 2018, 2019))

age_group_input <- checkboxGroupInput(
  "age_group",
  label = h3("Age Group"),
  choices = list("15 to 19" = "15 to 19",
                 "20 to 24" = "20 to 24",
                 "25 to 49" = "25 to 49",
                 "50 to 74" = "50 to 74 years",
                 "75 plus" = "75 plus"),
  selected = c("15 to 19", "20 to 24", "25 to 49",
               "50 to 74 years", "75 plus")
)

metric_input <- radioButtons(
  "metric",
  label = h3("Metric"),
  choices = c("Rate per 100,000" = "Rate",
              "Total Estimate" = "Number"),
  selected = "Rate")

# age ui

age_page <- tabPanel(
  "Accidents by Age Group",
  sidebarLayout(
    sidebarPanel(
      years_input,
      age_group_input,
      metric_input,
      state_input
    ),
    mainPanel(
      h3("Deaths and DALYs from Road Injuries by Age Group"),
      plotOutput("age_scatter"),
      h3("Fatal Accidents by State Separated by Age Group"),
      plotOutput("age_bar"),
      textOutput(outputId = "age_analysis")
    )
  )
)

# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- navbarPage(
  "Title",
  map_page,
  age_page
  #insert other pages here
)
