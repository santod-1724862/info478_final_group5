# load packages 
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

source("map_server.R")




# ------- INTERACTIVE VISUALIZAION PLOT ------- 
server <- function(input, output) {
  
  # further clean and/or manipulate the data based on the input from the widgets
  # any code that has input$ or output$ (ex. Your chart or a dataframe that 
  # will updated based on user input 
  # insert code for chart here
  
  map_function(input, output)
    # filters the dataset from the widgets 
    
 
    
    # create plot
    
  output$age_scatter <- renderPlot({
    
    filtered_scatter <- age_data %>%
      filter(year %in% input$years) %>%
      filter(age_name %in% input$age_group) %>%
      filter(metric_name == input$metric)
    
    age_scatter_plot <- filtered_scatter %>%
      ggplot(aes(x = Deaths, y = DALYs, color = age_name)) +
      geom_point() +
      labs(title = "Deaths vs. DALYs by Age Group", color = "Age Group")
    
    return(age_scatter_plot)
    
  })
  
  output$ratio_scatter <- renderPlot ({
    filtered_rr <- state_OR_RR %>%
      filter(State %in% input$state_or_rr)
    
    ggplot(state_OR_RR, aes(y=check_OR_state(state_OR_RR, input$state_or_rr), x=check_RR_state(state_OR_RR, input$state_or_rr))) + 
      geom_point() +
      labs(title="Odds Risk and Relative Risk", x = "Relative Risk", y = "Odds Risk")
  })

  
  output$age_bar <- renderPlot({
    
    filtered_bar <- age_data %>%
      filter(location_name == input$state) %>%
      filter(year %in% input$years) %>%
      filter(age_name %in% input$age_group) %>%
      filter(metric_name == input$metric)
    
    age_col_plot <- filtered_bar %>%
      ggplot(aes(x = year, y = Deaths, fill = age_name)) +
      geom_col() +
      labs(title = paste0("Estimated Fatal Accidents in the state of ",
                          input$state), x = "Year",
           y = paste0("Fatalities from Accidents (",
                      input$metric, ")"),
           fill = "Age Group")
    
    return(age_col_plot)
    
  })
  
  output$age_analysis <- renderText({
    paste("These two plots go in tandem to represent the differences of the impact
          and frequency of serious and fatal car accidents across age groups. When including
          all age groups with the selection boxes, you are able to see the clear differences
          between the five ranges, and it appears that the trend remains consistent
          accross space. There very similar distributions of fatal accidents for each age group
          when comparing different states, showing that the most total deaths come
          from the age groups: 25 to 49 and 50 to 74. This is cleary a result of those
          groups including a wider age range than the other three groups leading to a larger population,
          but when looking at the rate of fatal accidents per 100,000, these two groups account
          for the smallest proportion of fatal accidents, potentially indicating safer
          driving in those age ranges. The highest rates of fatal accidents come from age groups 20 to 24
          and 75 plus, as can be seen in the bar chart for most states and the fact that the decrease
          in DALYs for those age groups compared to the group directly before it on the scatterplot
          much less than is seen for the other age groups. The fact that this is a trend that
          remains so consistent across time and space indicates that there is some difference in
          either driving environment/conditions or driving skill/habits. For ages 20-24, there is
          potential of overconfidence on the roadway compared to people 15-19 that are just
          learning to drive, whereas the 75 plus group may be experiencing slower reaction times
          due to age and a lack of ability to perform safe manuevers in a dangerous situation on the
          road.")
  })
}
