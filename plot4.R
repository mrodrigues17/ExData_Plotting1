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

#fourth plot
png(file = "plot4.png")
par(mfrow = c(2,2))
with(power_data, plot(Dates, Global_active_power, ylab = expression("Global Active Power"~ 
                                                                      "(kilowatts)"), type = "l"))
with(power_data, plot(Dates, Voltage, type = "l"))

with(power_data, plot(Dates, Sub_metering_1, type = "l", ylab = "Energy sub metering"))
with(power_data, lines(Dates, Sub_metering_2, type = "l", col = "red"))
with(power_data, lines(Dates, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)

with(power_data, plot(Dates, Global_reactive_power, type = "l", ylab = "Global_reactive_power"))
dev.off()