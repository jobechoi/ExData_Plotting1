makePlot1<-function(){
  # If these packages need to be installed, uncomment  
  # the following set of install calls:
  #install.packages("RSQLite")
  #install.packages("sqldf")
  #install.packages("lubridate")
  
  
  # Set df to filtered read output on Dates '1/2/2007' or '2/2/2007'
  library(sqldf)
  df<- read.csv.sql("household_power_consumption.txt",
                    "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'",
                    sep=";")
  
  # # Fix some date and time formatting
  # library(lubridate)
  # df$Date<-mdy(df$Date)
  # df$Time<-hms(df$Time)
  # 
  # Open png file to capture plot
  png("plot1.png", 480, 480)
  
  # Make plot1
  hist(df$Global_active_power, 
       main="Global Active Power", 
       ylab="Frequency", 
       xlab="Global Active Power (kilowatts)", 
       col = "red")
  
  # Close file
  dev.off()
}
