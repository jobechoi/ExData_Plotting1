makePlot2<-function(){
  # If these packages need to be installed, uncomment  
  # the following set of install calls:
  # install.packages("RSQLite")
  # install.packages("sqldf")
  # install.packages("lubridate")
  # install.packages("ggplot2")
  
  library(sqldf)
  library(lubridate)
  library(ggplot2)
  
  # Set df to filtered read output on Dates '1/1/2007' or '1/2/2007'
  df<- read.csv.sql("household_power_consumption.txt",
                    "SELECT * FROM file WHERE Date = '2/1/2007' OR Date = '2/2/2007'",
                    sep=";")
  
  # Fix some date and time formatting
  df$dt<-paste(df$Date,df$Time,sep=" ")
  df$dt<-mdy_hms(df$dt,tz="UTC")

  # Open png file to capture plot
  png("plot2.png", 480, 480)
  
  # Make plot2
  ggplot(df, aes(x=df$dt, y=df$Global_active_power)) + 
         geom_line() + 
         labs(y = "Global Active Power (kilowatts)",x="") + 
         theme_bw() + 
         theme(panel.grid = element_blank(),panel.background = element_blank())
  # Close file
  dev.off()
  }