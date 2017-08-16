#Required packages
require(dplyr)
require(ggplot2)
require(ggrepel)

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
SCC$EI.Sector<-as.character(SCC$Data.Category)
vehicle_SCC<-SCC[grep("[Oo]nroad",SCC$Data.Category),1]
vehicle_SCC<-as.numeric(levels(vehicle_SCC))[vehicle_SCC]

plot5_dat<-NEI[NEI$SCC %in% vehicle_SCC,]
plot5_dat<-plot5_dat%>%
        filter(fips==24510)%>%
        group_by(year)%>%
        summarise(Total_emission=sum(Emissions))
# Set the Graphics device
png("Plot5.png",height =480,width = 480)

# Plot the data
plot5<-ggplot(plot5_dat,aes(year,Total_emission,label=as.character(year)))

# Add lines and text
plot5+geom_point()+
        geom_line()+
        geom_text_repel()+
        labs(x="Year", y="Total PM2.5 Emission (tons)",
             title="PM2.5 Emission from Motor Vehicles"
             ,subtitle="Baltimore City",caption="Plot 5")

dev.off()
setwd("../")
