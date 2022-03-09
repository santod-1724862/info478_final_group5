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
    
  
}
