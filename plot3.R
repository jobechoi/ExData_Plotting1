makePlot3<-function(){
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

  # Load the appropriate libraries  
  library(sqldf)
  library(lubridate)
  library(ggplot2)
  library(scales)
  
  # Energy data file must be in working directory with plot3.R
  # Set df to filtered read output on Dates '1/1/2007' or '1/2/2007'
  # df<- read.csv.sql("household_power_consumption.txt",
  #                   "SELECT * FROM file WHERE Date = '2/1/2007' OR Date = '2/2/2007'",
  #                   sep=";")
  
  # Fix some date and time formatting
  df$dt<-paste(df$Date,df$Time,sep=" ")
  df$dt<-mdy_hms(df$dt,tz="UTC")
  
  # Open device to print plot to plot3.png
  # png("plot3.png", 480, 480)
  # 
  # print(
    ggplot(data=df,aes(x=df$dt)) +
    
    # Plot the 3 lines for sub metering 1 through 3 and set color 
    # aesthetic to invoke legend
    geom_line(aes(y=df$Sub_metering_1, color="black")) +
    geom_line(aes(y=df$Sub_metering_2, color="red")) +
    geom_line(aes(y=df$Sub_metering_3, color="blue")) +
    labs(y = "Energy sub metering",x="") + 
    
    # Set x-axis labels and breaks to abbreviated day
    scale_x_datetime(name=waiver(),breaks = waiver(),date_breaks = "1 days",
                     labels = date_format("%a", tz = "UTC")) +
    
    # Format and position legend and plot area
    theme_bw() + 
    theme(legend.title=element_blank()) + 
    scale_color_manual(labels = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                       values = c("black","blue","red")) +
    theme(legend.background = element_rect(colour="black",linetype = "solid")) +
    theme(legend.key.height = unit(10,"pt")) +
    theme(legend.justification = c("right","top")) +
    theme(legend.position = c(1,1)) +
    theme(panel.grid = element_blank(),panel.background = element_blank())
  # )
  
  # Close file
  # dev.off()
}