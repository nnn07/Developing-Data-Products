library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel("Stock Analysis"),
  
  sidebarPanel(
    
    textInput("symb", "Stock Code", "AAPL"),
    
    dateRangeInput("dates", 
                   "Period",
                   start = "2016-01-01", end = "2016-12-31"),
    
    actionButton("get", "GO"),
    
    br(),
    br(),
    
    uiOutput("newBox")
    
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Instructions", 
               h3("Description"),
               p(textOutput("text1"),textOutput("text2")),
               h3("Stock Selected"),
               p(textOutput("text3")),
               h3("Period Selected"),
               p(textOutput("text4"))),
      tabPanel("Charts", plotOutput("chart")), 
      
      id = "tab"
    )
  )
))