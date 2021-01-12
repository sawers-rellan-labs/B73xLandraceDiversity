# A script to extract environmental variables from list of coordinates
# By Andi Kur
# Date: 1/11/21

#Load in libraries:
library(raster)
library(sp)
library(rgdal)
library(foreach)
library(dplyr)
library(ggplot2)
library(ggfortify) #for the PCA
library(MaizePal)
library(viridis) # just for plotting aesthetics
library(cowplot) # just for plotting aesthetics


# with this script, we can extract environmental variables contained in geotiff 
# files for a list of lat-lon pairs (the place where an accession was collected)
# For this, we need 2 basic things:
# 1) a file containing a lsit of accessions with their corresponding lat/lon values
# 2) a geotiff file containing the environmental information
#     for climatic data, use http://www.worldclim.org/



# Load in the file containing the list of accessions with their corresponding coordinates
# We only need 4 columns: accession, latitude, longitude, and elevation

landrace <- read.csv("Data/popbasics.csv")
head(landrace)

#load location coordinates as SpatialPoints

sp <- SpatialPoints(coords= cbind(landrace$Donor_Lon,landrace$Donor_Lat))

#get bioclim data
r <- getData("worldclim",var="bio",res=10)

#extract bioclim data for each set of coordinates
values <- extract(r,sp)

#create a dataframe to hold the accession, coordinates, and bioclim data, and elevation

  #coordinates
  df <- cbind.data.frame(coordinates(sp),values)
  #elevation
  df <- cbind.data.frame(df, landrace$Donor_Ele)
  #adding accession ID
  row.names(df) <- paste(landrace$Line) 

#rename the columns
names(df)[names(df) == "coords.x1"] <- "Longitude"
names(df)[names(df) == "coords.x2"] <- "Latitude"
names(df)[names(df) == "landrace$Donor_Ele"] <- "Elevation"

# Quick check to make sure the new df matches the old
head(df)
head(landrace) 

#check number of rows to make sure we still have the same number of accessions
nrow(landrace)
nrow(df)

#finally, we can write these data to a csv
write.csv(df, file="B73xLandrace_env.csv")

#to do a PCA

pal <- maize_pal("MaizMorado")

#run the PCA on values so as to not include lat, long, & elevation
pca <- prcomp(values, scale=TRUE)
lat <- autoplot(pca, data = df, colour = 'Latitude', size=3) +
  scale_color_gradientn(colours=pal) 

lon <- autoplot(pca, data = df, colour = 'Longitude', size=3) +
  scale_color_gradientn(colours=pal) 
       
ele <- autoplot(pca, data = df, colour = 'Elevation', size=3) +
  scale_color_gradientn(colours=pal) 
