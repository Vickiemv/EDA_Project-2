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

# Set the Graphics device
png("Plot3.png",height =480,width = 480)
# Subset required Data
# Sum the total emissions per year and per type
plot3_dat<-NEI%>%filter(fips==24510)%>%     
            group_by(year,type)%>%summarise(total_emissions=sum(Emissions))   
# Plot the data
plot3<-ggplot(plot3_dat,aes(year,total_emissions,label=as.character(year))) 

# Add the point and lines
plot3+geom_point()+
      geom_line()+
      facet_wrap(~type)+
      geom_text_repel()+
      labs(x="Year",y="Total PM2.5 Emission (tons)",
           title="Total Emissions PM2.5 for each type ",subtitle="Baltimore City",
           caption="Plot 3")
dev.off()
setwd("../")