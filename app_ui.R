
#install packages
library(shiny)
library(ggplot2)
library(plotly)
library(bslib)

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

#or and rr temperature
or_state_input <- selectInput(
  "state_or_rr",
  label=h3("Select State"),
  choices = unique(state_OR_RR$State)
)

temp_input <- numericInput("temp", "Temperature", value = 60, min = -10, max = 110)

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

tempature_or_rr_page <- tabPanel(
  "Tempature Relative Risk and Odds Risk",
  sidebarLayout(
    sidebarPanel(
      or_state_input,
      temp_input
    ),
    mainPanel (
      h3("Relative Risk and Odds Risk Comparison by Tempature"),
      plotOutput("ratio_scatter"),
    )
  )
)

summary_panel <- tabPanel(
  "Project Details",
  # All paragraphs on main panel
  mainPanel(
    tags$h1(
      id = "conclusion",
      paste("Main Insights")
    ),
    tags$h4(id = "conclusion",
            paste("Interactive Map Takeaways")),
    tags$p(
      id = "conclusion",
      paste("The interactive map of the US provides a better overview of how different parts of the
            country differ in driving realted accidents. The reported deaths per 100,000 shows that the 
            majority of accidents tend to be focused in more central and southeastern states and less 
            along the west and east coasts. Over time states had kept a similar death rate.")
    ),
    tags$h4(id = "Conclusion",
            paste("Accidents by Age Group Takeaways")),
    tags$p(
      id = "conclusion",
      paste("Looking at the total estimates of accidents can be misleading as the dataset has less 
            occurrences in states that would be indicated of higher risk through the map interactive.
            However, looking at deaths per 100,000 shows that certain states have higher rates of accidents.
            Also, despite not being the majority population ages 20-24 and over 75+ contributed most
            to the total death rate per 100,000 during the 4 year period.")
    ),
    tags$h4(id = "conclusion",
            paste("High Temp & High Severity OR/RR Insights")),
    tags$p(
      id = "conclusion",
      paste("For this graph we attempted to record RR and OR values for the dataset. Initially, 
            we wanted users to be able to pick the temperature cut-off point and all temperatures above
            a certain point will be assigned as 'High_Temp' and see how this intersects with how severe an
            accident is. The numbers reported show the relative risk of getting into a high severity accident
            given that the temperature is above a certain point." )
    ),
    tags$h1(
      id = "data_collection",
      paste("Main Sources of Data Collection and Methods Used")
    ),
    tags$p(
      id = "data_collection",
      paste("For our sources we had to take datasets from three separate locations. The first two 
            data sets found were from CDC datand the GBD compare tool.")
    ),
    h3("Data Cleaning Process"),
    p("Our largest data set came from Kaggle and was compiled using an API by a scientist working 
            for Lyft(tm). This set originally came with over a million entries but was reduced to 45k rows
            after filtering NA values and accidents with a severity score of 2 or below."),
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
            individuals in relation to GBD visualizations. Each row reported the total death or death rate which reduced the amount of 
            calculations we could do")
    )
  )
)

intro_panel <- tabPanel(
  title = "Project Summary",
  mainPanel(
    tags$h2(
      id = "intro_title",
      paste("Traffic Accident Analysis: David, Derrick, Jason, & Jeremiah")
    ),
    p(
      id = "intro_paragraph",
      "We intitially set out for the purpose of understanding the extent different risk
            factors affect the prevalence of driving related accidents. Due to problems with data 
            collection we decided to look at factors such as", strong(" age, temperature and location "),"to better understand trends that occur in the United States. We will mostly 
            be concerned with high severity accidents versus low severity accidents and how these
            may differ or share similarities to each other. Some questions we want to find are how does 
      age account for the distribution of accidents in the US? What is the risk that temperature poses on the
      severity of the accident? Where are driving related deaths most prevalent? Does alcohol account for rising
      death rates in various states?"),
    tags$h2(
      id = "Future_Research",
      paste("Looking Towards the Future")
    ),
    tags$p(
      id = "intro_paragraph",
      paste("We wanted the information derived from analysis to fit into the entirety of US
            demographic. Future research could look into the prevalence of death rates in more central
            located states such as Wyoming, Montana, or even Loiusiana. Perhaps an interesting metric to 
            look at as well is we were given more time is road conditions as well.")
    )
  )
)

# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- navbarPage(
  theme = bs_theme(version = 4, bootswatch = "minty"),
  titlePanel("US Driving Death Analysis"),
  intro_panel,
  map_page,
  age_page,
  tempature_or_rr_page,
  summary_panel
  #insert other pages here
)

