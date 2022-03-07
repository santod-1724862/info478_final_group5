
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


# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- navbarPage(
  "Title",
  page_one,
  map_page
  #insert other pages here
)
