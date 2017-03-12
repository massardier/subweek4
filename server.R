
library(shiny)
library(data.table)
library(ggplot2)
library(leaflet)

crimes <- fread("./crime_ment.csv")

crimes[,lat:=as.numeric(substr(Location,start = 2,17))]
crimes[,lng:=as.numeric(substr(Location,start = 20,36))]

c2 <- crimes[,.(lat,lng,Date,PdDistrict,Resolution)]
c3<- c2[complete.cases(c2)]
c3[,date:=as.Date(Date,"%m/%d/%Y %H:%M:%S")][,year:=year(date)]
c4<-c3[,.(number_of_cases=.N),by=.(year,PdDistrict)]

# Define server logic required to plot events
shinyServer(
  function(input, output, session) {
    
    output$mymap <- renderLeaflet({
      c3[year==as.numeric(input$year)] %>% 
        leaflet() %>% 
        addTiles(options = tileOptions(minZoom=11, maxZoom=15)) %>% 
        addMarkers(clusterOptions=markerClusterOptions())%>%
        setView(lng = "-122.4500", lat = "37.7816", zoom = 12)
      
    })
    
    output$myplot <- renderPlot({
      
      # Render a barplot
      ggplot(c4[year==as.numeric(input$year)],
             aes(PdDistrict,number_of_cases,fill=PdDistrict))+
        geom_bar(stat="identity")+
        theme(axis.text.x = element_text(angle=90))+
        ggtitle(label="Number of episodes per Police District")+
        labs(x="",y="")
    })
    
  })
