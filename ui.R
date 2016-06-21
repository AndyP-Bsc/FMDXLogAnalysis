library(shiny)

shinyUI(fluidPage(

  # Application title
  headerPanel("FM DX Interactive Log Analysis",windowTitle = "FM DX Interactive Log Analysis"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      
      #
      # Drop downs
      # 
      
      selectInput("idYear", label = h4("Year"), 
                  choices = list("All" = "All", "2014" = "2014", "2015" = "2015"), 
                  selected = "All"),

      selectInput("idMonth", label = h4("Month"), 
                  choices = list("All" = "All", 
                                 "January (01)" = "01", 
                                 "February (02)" = "02", 
                                 "March (03)" = "03", 
                                 "April (04)" = "04", 
                                 "May (05)" = "05", 
                                 "June (06)" = "06", 
                                 "July (07)" = "07", 
                                 "August (08)" = "08", 
                                 "September (09)" = "09", 
                                 "October (10)" = "10", 
                                 "November (11)" = "11", 
                                 "December (12)" = "12"
                  ), 
                  selected = "All"),
      
      
      
      selectInput("idProp", label = h4("Signal Propagation Mode"), 
                  choices = list("All" = "All", 
                                 "Aurora" = "Aur", 
                                 "Meteor Scatter" = "MS", 
                                 "Sporadic E" = "Es",
                                 "Tropospheric" = "Tropo"), 
                  selected = "All"),

      #
      # Help link
      #
      a(href="helpfile.htm", "Read the supporting documentation")   
      
    ),
    
    mainPanel(
      plotOutput("plotAnalysis"),
      
      h2("Calculations"),
      verbatimTextOutput("totalLogs"),
      verbatimTextOutput("distMin"),
      verbatimTextOutput("distMax"),
      verbatimTextOutput("distAvg")
      
      
    )
  )
))
