library(ggplot2)
#stock data:
stock.name <- "Volkswagen"
stock <- "VOW.DE"
stock.colours <- c("#2158a4", "grey90", "#ed6e14")
start.date <- "2014-01-01"
end.date <- "2015-12-31"
quote <- paste("http://ichart.finance.yahoo.com/table.csv?s=",
               stock,
               "&a=", substr(start.date,6,7),
               "&b=", substr(start.date, 9, 10),
               "&c=", substr(start.date, 1,4), 
               "&d=", substr(end.date,6,7),
               "&e=", substr(end.date, 9, 10),
               "&f=", substr(end.date, 1,4),
               "&g=d&ignore=.csv", sep="")             
stock.data <- read.csv(quote, as.is=TRUE)

stock.data$Day <- as.POSIXlt(stock.data$Date)$mday
stock.data$year <- as.POSIXlt(stock.data$Date)$year + 1900
stock.data$Month <- months(as.POSIXlt(stock.data$Date))
stock.data$Month <- factor(stock.data$Month, levels=rev(c("January","February","March","April","May","June","July","August","September","October","November","December")))
stock.data$dailychange<-c(0,-1*(diff(stock.data$Adj.Close,lag=1)))

baseplot <- ggplot(stock.data[-(1:3),], aes(Day, Month, colour=dailychange, fill = dailychange)) +
geom_point(size=6) +
scale_fill_gradientn(name="Closing\nPrice\nDifference", colours = stock.colours) +
  scale_colour_gradientn(name="Closing\nPrice\n(adj)", colours = stock.colours) +
facet_wrap(~ year, ncol = 1) + theme_minimal()

baseplot + xlab("Day") + ggtitle(paste(stock.name, "Stocks", start.date, "-", "Present" , sep=" "))

# scale_y_continuous(name = "Day", breaks = 1:5, labels = c("Monday", "Tuesday","Wednesday", "Thursday" , "Friday"), trans = "reverse") + 

