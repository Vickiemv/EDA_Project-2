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

plot6_dat<-NEI[NEI$SCC %in% vehicle_SCC,]
plot6_dat<-plot6_dat%>%
        filter(fips==c("24510","06037"))%>%
        group_by(year,fips)%>%
        summarise(Total_emission=sum(Emissions))

# Convert fips into a factor with appropriate labels
plot6_dat$fips<-factor(plot6_dat$fips,level=c("06037","24510"),
                          label=c("Los Angeles County","Baltimore City"))

# Plot the data
plot6<-ggplot(plot6_dat,aes(year,Total_emission,label=as.character(year)))
                            
# Add lines and text
plot6+geom_point()+
        geom_line()+
        facet_grid(fips~.)+
        geom_text_repel()+
        labs(x="Year", y="Total PM2.5 Emission (tons)",
             title="PM2.5 Emission from Motor Vehicles"
             ,subtitle="Baltimore City vs Los Angeles County ",caption="Plot 6")

# Save the plot 
ggsave("Plot6.png")

setwd("../")
