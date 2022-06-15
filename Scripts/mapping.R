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
library(viridis)
#load in data

landrace <- read.csv("Data/LANGEBIO_B73_POPS.csv")

#create variables from data
landrace$Donor_Lon <- as.numeric(landrace$Donor_Lon)
landrace$Donor_Lat <- as.numeric(landrace$Donor_Lat)
landrace$Donor_Ele <- as.numeric(landrace$Donor_Ele)
#id <- landrace$Line

landrace_hilo <- landrace_advanced %>%
  filter(Pop == "HiLo")

landrace_advanced <- landrace %>%
  filter(State != "Lost")


#create a basemap using get_map function
register_google("AIzaSyC7ysJP7aVkxc-r1fIPskFkUtRiKGkzxCk")
mylocation <- geocode("Ecuador")

basemap <- get_map( location =mylocation, maptype="satellite", color = "bw", zoom=3, 
                    source='google')
map <-ggmap(basemap,extent='panel', 
               base_layer=ggplot(landrace, 
                                 aes(x=Donor_Lon, y=Donor_Lat)))


#make a pallet 
#pal <- maize_pal("HighlandMAGIC")

#Time to map!
map + geom_point(aes(colour = Donor_Ele)) + scale_color_viridis(option="rocket") +
  xlim(-115,-35) + ylim(-35,35)

#some statistics

landrace %>%
  ggplot(aes( x = Donor_Ele, fill = Donor_Ele)) +
  geom_density() +
  theme_cowplot()

#field data from CLY21

CLY21 <- read.csv("Data/CLY21_LANDB_Data.csv")

CLY21 %>%
  filter(Who.What=="LANTEO") %>%
  ggplot(aes( x = GDUs, fill = Who.What)) +
  geom_histogram(alpha = 0.8, binwidth = 10) +
  theme_cowplot() +
  geom_vline(xintercept = 1630) 

