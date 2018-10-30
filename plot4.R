makePlot4<-function(){
  # If these packages aren't found we install them:
  # install.packages("RSQLite")
  # install.packages("sqldf")
  # install.packages("lubridate")
  # install.packages("ggplot2")
  # install.packages("scales")
  
  # Required by sqldf
  if(find.package("RSQLite")==""){
    install.packages("RSQLite")
  } 
  
  # File loading with inbound filtering using SQL
  if(find.package("sqldf")==""){
    install.packages("sqldf")
  }
  
  # Date conversion
  if(find.package("lubridate")==""){
    install.packages("lubridate")
  }
  
  # Plotting
  if(find.package("ggplot2")==""){
    install.packages("ggplot2")
  }
  
  # Helper for scaling plot
  if(find.package("scales")==""){
    install.packages("scales")
  }
  
  # Helper for multiple graphs
  if(find.package("gridExtra")==""){
    install.packages("gridExtra")
  }

  # Load the appropriate libraries  
  library(sqldf)
  library(lubridate)
  library(ggplot2)
  library(scales)
  library(gridExtra)
  
  # Energy data file must be in working directory with plot4.R
  # Set df to filtered read output on Dates '1/2/2007' or '2/2/2007'
  df<- read.csv.sql("household_power_consumption.txt",
                    "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'",
                    sep=";")
  
  # Fix some date and time formatting
  df$dt<-paste(df$Date,df$Time,sep=" ")
  df$dt<-dmy_hms(df$dt,tz="UTC")
  
  # Energy sub metering plot
  p1<-ggplot(data=df,aes(x=df$dt))
  p1<- p1 + geom_line(aes(y=df$Sub_metering_1, color="black"))
  p1<- p1 + geom_line(aes(y=df$Sub_metering_2, color="red"))
  p1<- p1 + geom_line(aes(y=df$Sub_metering_3, color="blue"))
  p1<- p1 + labs(y = "Energy sub metering",x="") 
  p1<- p1 + scale_x_datetime(name=waiver(),breaks = waiver(),date_breaks = "1 days",
                             labels = date_format("%a", tz = "UTC")) 
  p1<- p1 + theme_bw() 
  p1<- p1 + theme(legend.title=element_blank()) 
  p1<- p1 + scale_color_manual(labels = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                               values = c("black","blue","red")) 
  p1<- p1 + theme(legend.background = element_rect(fill = alpha("yellow", 0.74))) 
  p1<- p1 + theme(legend.key.height = unit(10,"pt")) 
  p1<- p1 + theme(legend.justification = c("right","top")) 
  p1<- p1 + theme(legend.position = c(1,1))
  p1<- p1 + theme(panel.grid = element_blank(),panel.background = element_blank())
  p1<- p1 + theme(axis.title.x = element_text(margin = margin(t=20)))
  p1<- p1 + theme(axis.title.y = element_text(margin = margin(r=20)))
  
  # Global active power plot
  p2<-ggplot(data=df,aes(x=df$dt)) 
  p2<- p2 + geom_line(aes(y=df$Global_active_power)) 
  p2<- p2 + labs(y = "Global Active Power (kilowatts)",x="")
  p2<- p2 + scale_x_datetime(name=waiver(),breaks = waiver(),date_breaks = "1 days",
                             labels = date_format("%a", tz = "UTC")) 
  p2<- p2 + theme_bw() 
  p2<- p2 + theme(legend.title=element_blank()) 
  p2<- p2 + theme(panel.grid = element_blank(),panel.background = element_blank())
  p2<- p2 + theme(axis.title.x = element_text(margin = margin(t=20)))
  p2<- p2 + theme(axis.title.y = element_text(margin = margin(r=20)))
  
  # Voltage plot
  p3<-ggplot(data=df,aes(x=df$dt)) 
  p3<- p3 + geom_line(aes(y=df$Voltage)) 
  p3<- p3 + labs(y = "Voltage",x="datetime")
  p3<- p3 + scale_x_datetime(name=waiver(),breaks = waiver(),date_breaks = "1 days",
                             labels = date_format("%a", tz = "UTC")) 
  p3<- p3 + theme_bw() 
  p3<- p3 + theme(legend.title=element_blank()) 
  p3<- p3 + theme(panel.grid = element_blank(),panel.background = element_blank())
  p3<- p3 + theme(axis.title.x = element_text(size=7))
  p3<- p3 + theme(axis.title.x = element_text(margin = margin(t=20)))
  p3<- p3 + theme(axis.title.y = element_text(margin = margin(r=20)))  
  
  # Global_reactive_power plot
  p4<-ggplot(data=df,aes(x=df$dt)) 
  p4<- p4 + geom_line(aes(y=df$Global_reactive_power)) 
  p4<- p4 + labs(x="datetime", y="Global_reactive_power")
  p4<- p4 + scale_x_datetime(name=waiver(),breaks = waiver(),date_breaks = "1 days",
                             labels = date_format("%a", tz = "UTC")) 
  p4<- p4 + theme_bw() 
  p4<- p4 + theme(legend.title=element_blank()) 
  p4<- p4 + theme(panel.grid = element_blank(),panel.background = element_blank())
  p4<- p4 + theme(axis.title.x = element_text(size=7))
  p4<- p4 + theme(axis.title.x = element_text(margin = margin(t=20)))
  p4<- p4 + theme(axis.title.y = element_text(margin = margin(r=20)))
  
  png("plot4.png", 480, 480)
  grid.arrange(p2,p3,p1,p4,nrow=2,ncol=2)
  dev.off()
}
