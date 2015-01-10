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

## Create the Plot1
png(filename="plot1.png", width=480,   height=480, )
hist(data$Global_active_power,col ="red",main ="Global Active power", xlab="Global Active power (Killowats)", ylab="Frequency")
dev.off()

