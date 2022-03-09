
#install packages
library(shiny)
library(ggplot2)
library(plotly)

# source pages
source("map_ui.R")
source("analysis.R")
# read dataset 

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
  titlePanel("Accidents by Age Group"),
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

summary_panel <- tabPanel(
  title = h2("Project Details"),
  # All paragraphs on main panel
  mainPanel(
    tags$h1(
      id = "conclusion",
      paste("Main Takeaways")
    ),
    tags$p(
      id = "conclusion",
      paste("This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.
            This is the area I set aside to report all findings.")
    ),
    tags$h1(
      id = "data_collection",
      paste("Main Sources of Data Collection and Methods Used")
    ),
    tags$p(
      id = "data_collection",
      paste("For our sources we had to take datasets from three separate locations. The first two 
            data sets found were from CDC datand the GBD compare tool. --HOW WERE THESE CLEANED--.
            Our largest data set came from Kaggle and was compiled using an API by a scientist working 
            for Lyft(tm). This set originally came with over a million entries but was reduced to 45k rows
            after filtering NA values and accidents with a severity score of 2 or below.")
    ),
    tags$h1(
      id = "limitations",
      paste("Limitations of Insights Derived from Datasets")
    ),
    tags$p(
      id = "limitations",
      paste("One major limitation that should be noted is that the population sample had to be
            drasticially reduced in order for the file to be uploaded onto GitHub. The cleaning 
            mentioned in our data collection removed a large majority of accidents and thus we had to
            adjust our questions to focus on causes of severe accidents rather than all traffic accidents.
            The validity of looking at temperature, humidity, and associated OR/RR values may be low
            due to the dataset being taken of Kaggle and not officially collected. 
            
            The GBD data reported on the aggregate of various risk factors which may reduce the ability for insights to apply to 
            individuals. Each row reported the total death or death rate which reduced the amount of 
            calculations we could do")
    )
  )
)

# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- navbarPage(
  "US Driving Death Analysis",
  map_page,
  age_page,
  summary_panel
  #insert other pages here
)

