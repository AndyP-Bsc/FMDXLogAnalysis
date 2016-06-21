library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {

  #load data
  logBook <- read.csv("FMDXLogBook.csv")
  
  #char to date
  logBook$DT <- strptime(logBook$DateTime,"%d/%m/%Y %H:%M", tz="GMT")
  
  #extract month and year for speed
  logBook$Year <- as.numeric(format(logBook$DT,"%Y"))
  logBook$Month <- as.numeric(format(logBook$DT,"%m"))
  logBook$Day <- as.numeric(format(logBook$DT,"%d"))
  
  #dummy column for couting
  logBook$CNT <- 1
  
  #extract columns: PropMode Distance Year Month Day CNT
  logBook <- logBook[,c(2,3,5,6,7,8)]
  
  #fudge to fix axis's
  axisFixMonth <- data.frame(PropMode=rep("Es",12),
                             Distance=rep(0,12),
                             Year=rep("1970",12),
                             Month=c(1:12),
                             Day=rep("01",12),
                             CNT=rep(0,12))  

  #fudge to fix axis's
  axisFixDay <- data.frame(PropMode=rep("Es",31),
                             Distance=rep(0,31),
                             Year=rep("1970",31),
                             Month=rep("01",31),
                             Day=c(1:31),
                             CNT=rep(0,31))
  

  ###
  ### Main UI handler
  ###
  output$plotAnalysis <- renderPlot({
    
    #
    # Choose All or Year Specific
    #
    if (input$idYear == "All")
      plotData <- logBook
    else
      plotData <- subset(logBook, logBook$Year == as.numeric(input$idYear))
    
    #
    # Choose All or Prop Mode Specific
    #
    if (input$idProp == "All")
      plotData <- plotData
    else
      plotData <- subset(plotData, plotData$PropMode == input$idProp)
    
    
    #
    # Choose All or Month Specific
    #
    if (input$idMonth == "All")
      plotData <- plotData
    else
      plotData <- subset(plotData, plotData$Month == as.numeric(input$idMonth))
    
    # CALCULATIONS
    calcData <- plotData #copy data as shiny doing lazy execution
    output$totalLogs <- renderText( paste("Total Logs", nrow(calcData) ) )
    
    #check for data
    if (nrow(calcData)>0)
    {
      #calculate min, max and avg
      output$distMin <- renderText( paste("Minimum distance in miles", round(min(calcData$Distance),0) ) )
      output$distMax <- renderText( paste("Maximum distance in miles", round(max(calcData$Distance),0) ) )
      output$distAvg <- renderText( paste("Average distance in miles", round(mean(calcData$Distance),0) ) )
    }
    else
    {
      #flag NO DATA
      output$distMin <- renderText("NO DATA")
      output$distMax <- renderText("NO DATA")
      output$distAvg <- renderText("NO DATA")
    }
    
    
    
    #
    # If not Month Specific then display Month's 1 to 12 
    # otherwise days 1 to 31
    #    
    if (input$idMonth=="All")
    {
      #add axis fix
      plotData <- rbind(plotData,axisFixMonth)
      
      #group by Month and sum
      plotData <- summarise(group_by(plotData,Month),sum(CNT))
      
      #plot
      plotObj <- ggplot(data=plotData, aes(factor(Month),`sum(CNT)`))+
        geom_bar(stat="identity") +
        labs(x="Month",y="Total Logs") +
        theme(axis.title=element_text(size=14,face="bold"))      
    }
    else
    {
      #add axis fix
      plotData <- rbind(plotData,axisFixDay)
      
      #group by Day for the specific Month and sum
      plotData <- summarise(group_by(plotData,Day),sum(CNT))
      
      #plot
      plotObj <- ggplot(data=plotData, aes(factor(Day),`sum(CNT)`))+
        geom_bar(stat="identity") +
        labs(x=paste0("Days in Month ",input$idMonth),y="Total Logs") 
      
    }
    
    #render
    plotObj
    
  })
  

})
