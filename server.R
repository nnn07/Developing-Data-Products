library(shiny)
library(quantmod)
library(VGAM)

shinyServer(function(input, output) {
  
  # acquiring data
  dataInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      getSymbols(input$symb,src="google", auto.assign = FALSE)
    }))
  })
  
  datesInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      paste0(input$dates[1], "::",  input$dates[2])
    }))
  })
  
  returns <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    dailyReturn(dataInput())
  })
  
  xs <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    span <- range(returns())
    seq(span[1], span[2], by = diff(span) / 100)
  })
  
  # tab based controls
  output$newBox <- renderUI({
    switch(input$tab,
           "Charts" = chartControls
    )
  })
  
  # Charts tab
  chartControls <- div(
    wellPanel(
      selectInput("chart_type",
                  label = "Chart Type",
                  choices = c("Candlestick" = "candlesticks", 
                              "Matchstick" = "matchsticks",
                              "Bar" = "bars",
                              "Line" = "line"),
                  selected = "Candlestick"
      )
    ),
    
    wellPanel(
      p(strong("Please add technical analysis")),
      checkboxInput("ta_vol", label = "Volume", value = FALSE),
  
      br(),
      
      actionButton("chart_act", "Add")
    )
  )
  
  TAInput <- reactive({
    if (input$chart_act == 0)
      return("NULL")
    
    tas <- isolate({c(input$ta_vol)})
    funcs <- c(addVo())
    
    if (any(tas)) funcs[tas]
    else "NULL"
  })
  
  output$chart <- renderPlot({
    chartSeries(dataInput(),
                name = input$symb,
                type = input$chart_type,
                subset = datesInput(),
     
                theme = "white",
                TA = TAInput())
  })
  
  
  output$text1<- renderText({ 
    paste("Please refer to Google Finance to find the stock code")
  })
  
  output$text2<- renderText({ 
    paste("Go to Chart tab to view the analysis")
  })
  
  output$text3<- renderText({ 
    paste(input$symb)
  }) 
  
  output$text4<- renderText({ 
    paste(input$dates[1]," to ",input$dates[2])
  }) 
  
})