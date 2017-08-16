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
# Subset required Data
SCC$EI.Sector<-as.character(SCC$EI.Sector)
coal_SCC<-SCC[grep("[Cc]oal",SCC$EI.Sector),1]
coal_SCC<-as.numeric(levels(coal_SCC))[coal_SCC]

plot4_dat<-NEI[NEI$SCC %in% coal_SCC,]
plot4_dat<-plot4_dat%>%
        group_by(year)%>%
        summarise(Total_emission=sum(Emissions))
# Set the Graphics device
png("Plot4.png",height =480,width = 480)

# Plot the data
with(plot4_dat,plot(year,Total_emission,xlab="Year",ylab="Total PM2.5 Emission (tons)",
                    sub="Plot 4",main="Total PM2.5 Emission from Coal combustion vs Year",
                    pch=19,xlim=c(1998,2009),ylim = c(300000,600000)))

# Add lines and text
with(plot4_dat,lines(year,Total_emission,lwd=1.5))
with(plot4_dat,text(year+0.55,Total_emission+10000,as.character(year)))
dev.off()
setwd("../")


