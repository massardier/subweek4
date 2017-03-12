
library(shiny)

library(leaflet)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Yearly aided cases involving mental disturbance in San Francisco"),
  
  # Sidebar with a slider input for the year
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Display data for year:",
                  min = 2009,
                  max = 2016,
                  value = 2009),
      style = "position: fixed; ",
      helpText("Select a year between 2009 and 2016")
    ),
    
    # Show a plot per police district
    mainPanel(
      div("This data represents the number of non criminal incidents where the San Francisco Police Department attended an individual suffering an episode
          of mental disturbance. The dataset was taken from: ",a("SF OpenData",href="https://data.sfgov.org/Public-Safety/Map-Crime-Incidents-from-1-Jan-2003/gxxq-x39z")),
      br(),
      p("1. Filter by year in the left slider"),
      p("2. View the updated map of non criminal incidents in the 1st tab"),
      p("3. View the updated barplot of incidents by district in the 2nd tab"),
      tabsetPanel(
        tabPanel("Map", leafletOutput("mymap")), 
        tabPanel("Barplot",plotOutput("myplot"))
      )
      
    )
  )
))