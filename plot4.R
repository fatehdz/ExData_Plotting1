#Check for the availability of the Packages used and install them if necessary
packages <- c("dplyr", "lubridate")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
        install.packages(setdiff(packages, rownames(installed.packages())))  
}
library(dplyr)
library(lubridate)


# Download, unzip and read the file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

temp <- tempfile()
download.file(url , temp)
data <- read.csv(unz(temp, "household_power_consumption.txt"),sep =";" , na.strings = "?")
unlink(temp)

## filter the file
data <- data %>% filter(Date =="1/2/2007" | Date =="2/2/2007")%>% mutate(DateTime = paste (Date,Time))
data$DateTime <- as.POSIXct(data$DateTime, format="%d/%m/%Y %H:%M:%S") 
data$DateTime <- strptime(data$DateTime, format = "%d/%m/%Y %H:%M:%S")



## Create the Plot4
png(filename="plot4.png", width=480,   height=480,)
par(mfrow = c(2, 2), mar = c(4,4,2,1))
with(data, 
{
         
        plot(data$DateTime, data$Global_active_power, type ="l",  ylab="Global Active power (Killowats)", xlab="")
        plot(data$DateTime, data$Voltage, type ="l",  ylab="Voltage", xlab="datetime")
        plot(data$DateTime,data$Sub_metering_1,type ="l",
                      ylab="Energy sub metering",
                      xlab="", col = "black")
                 legend("topright",  lty = "solid", bty = "n", col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
                 par(new=T)
                 lines(data$DateTime,data$Sub_metering_2, col = "red")
                 par(new=T)
                 lines(data$DateTime,data$Sub_metering_3,col ="blue")                 
                 
                 plot(data$DateTime, data$Global_reactive_power, type ="l",  ylab="Global_reactive_power", xlab="datetime") 
                                            
                })
dev.off()

