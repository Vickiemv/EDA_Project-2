#Required packages
require(dplyr)

#Read data
dwnldfile<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destFile<-"exdata_data_NEI_data.zip"
if(!file.exists(destFile)){
        download.file(dwnldfile,destfile = destFile)
}
unzip(destFile,exdir="./data")
setwd("./data")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Set the Graphics device
png("Plot2.png",height =480,width = 480)
# Subset required Data
plot2_dat<-NEI%>%
        filter(fips==24510)%>%
        group_by(year)%>%
        summarise(Total_emission=sum(Emissions))

# Plot the data
with(plot2_dat,plot(year,Total_emission,xlab="Year",ylab="Total PM2.5 Emission (tons))",
                    sub="Plot 2",main="Total PM2.5 Emission in Baltimore City",pch=19,
                    xlim=c(1998,2009),ylim=c(1500,4000)))

# Add lines and text
with(plot2_dat,lines(year,Total_emission,lwd=1.5))
with(plot2_dat,text(year+0.55,Total_emission+100,as.character(year)))
dev.off()
setwd("../")