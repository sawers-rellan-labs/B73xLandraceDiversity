# A script to plot accessions from the B73 x Landrace Diversity Panel
# By Andi Kur
# Date: 1/1/2021 (wahoo!)

#Load in libraries:
library(tidyr)
library(plyr)
library(dplyr)
library(ggplot2)
library(magrittr)
library(rmarkdown)
library(cowplot)
library(ggmap)
library(maps)
library(MaizePal)
#load in data

landrace <- read.csv("data/LANGEBIO_B73_POPS.csv")

#create variables from data
landrace$Donor_Lon <- as.numeric(landrace$Donor_Lon)
landrace$Donor_Lat <- as.numeric(landrace$Donor_Lat)
landrace$Donor_Ele <- as.numeric(landrace$Donor_Ele)
#id <- landrace$Line


#create a basemap using get_map function
mylocation <- geocode("Latin America")

basemap <- get_map( location =mylocation, color='bw', zoom=3, 
                    source='google')
ggmap(basemap)


#make a pallet 
pal <- maize_pal("MaizMorado")

#Time to map!
map <-ggmap(basemap) +  #save the base layer map 
  geom_point(data = landrace,  #add the data points
             aes(x = Donor_Lon, 
                 y = Donor_Lat, 
                 colour = Donor_Ele), #color by elevation
             size=3) +
  xlim(-110,-30) + ylim(-35,32) + #set the bounding box to contain the data
  scale_color_gradientn(colours=pal) # add own color

map


