makePlot1<-function(rawdata){
  # If these packages need to be installed, uncomment  
  # the following set of install calls:
  #install.packages("RSQLite")
  #install.packages("sqldf")
  #install.packages("lubridate")
  
  
  # Set df to filtered read output on Dates '1/1/2007' or '1/2/2007'
  library(sqldf)
  df<- read.csv.sql(rawdata,
                    "SELECT * FROM file WHERE Date = '1/1/2007' OR Date = '1/2/2007'",
                    sep=";")
  
  # Fix some date and time formatting
  library(lubridate)
  df$Date<-mdy(df$Date)
  df$Time<-hms(df$Time)

  # Open png file to capture plot
  dev.print(png, file = "plot1.png")
  
  # Make plot1
  hist(df$Global_active_power, 
       main="Global Active Power", 
       ylab="Frequency", 
       xlab="Global Active Power (kilowatts)", 
       col = "red")
  
  # Close file
  dev.off()
}