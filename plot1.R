data1 <- "power_consumption.zip"

#download the file
if(!file.exists(data1)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, data1, method = "curl")
}
#unzip the file
if(!file.exists("household_power_consumption.txt")){
  unzip(data1)
}

library(data.table)
#use fread to read in the table
temp <- fread("household_power_consumption.txt")

#subset temp to get relevant dates
library(dplyr)
power_data <- filter(temp, Date %in% c("1/2/2007", "2/2/2007"))

#join Date and Time columns (to column "Dates)
power_data$Dates <- paste(power_data$Date, power_data$Time)
#remove date and time columns
power_data <- power_data[ , -c(1,2)]

#convert from character to date class
power_data$Dates <- strptime(power_data$Dates, format = "%d/%m/%Y %H:%M:%S")

#need to change other columns to numeric (all characters now)
power_data[,1:7] <- sapply(power_data[,1:7], as.numeric)

#first plot
png(file = "plot1.png")
hist(power_data$Global_active_power, col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()