#-------------------------------------------
#WORKSHOP GEOMUNDUS 2017 MUNSTER 11/11/2017
# load spatial data 2 gpx kml
#-------------------------------------------

#To understand whats going on execute line by line

#--------------------------------
# SET UP R ENVIRONMENT
#--------------------------------

#Load libraries
library(rgdal)
library(sp)
library(leaflet)

#Set working directory to your file location
# Rstudio Session>>Set Working directory>>to source file location
setwd("/geomundus2017")
wd=getwd()

#----------------------------------------
# list  OGR drivers
#----------------------------------------
ogrDrivers()

#Loading a gpx file
#to read track layer="track"
#to read waypoints layer="waypoints"
cougar<-readOGR(dsn="cougar.gpx", layer="waypoints") 

library(leaflet)

#an interactive map

#get coordinates for the maps form spatial data frame
coorx<-cougar@coords[,1]
coory<-cougar@coords[,2]

#plot the map
mapleaflet<-leaflet() %>%
  addTiles() %>%
  addMarkers(lng = coorx, lat=coory)
mapleaflet

#a headmap from points
require(MASS)
myheatmap<-kde2d(coorx, coory, h=0.01, n=600)

library(raster)
myheatmap=raster(myheatmap)

#plot the haeatmap

#defini colors
pal <- colorNumeric(c("#033609", "658869", "#C7DBC9"), values(myheatmap),
                    na.color = "transparent")

#plot
mapleaflet<-leaflet() %>%
  addTiles() %>%
  addRasterImage(myheatmap,  color=pal, opacity = 0.5)
  #addMarkers(lng = coorx, lat=coory)
mapleaflet

#Loading a kml file

#load camino from kml
camino<-readOGR(dsn="camino.kml")


#plot the map
mapleaflet<-leaflet(camino) %>%
  addTiles() %>%
  addPolylines()
mapleaflet

