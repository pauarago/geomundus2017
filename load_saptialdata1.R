#-------------------------------------------
#WORKSHOP GEOMUNDUS 2017 MUNSTER 11/11/2017
#-------------------------------------------

#To understand whats going on execute line by line

#--------------------------------
# SET UP R ENVIRONMENT
#--------------------------------

#install spatial libraries
install.packages("rgdal","sp")

#Laod libraries
library(rgdal)
library(sp)

#Set working directory to your file location
# Rstudio Session>>Set Working directory>>to source file location
setwd("/geomundus2017")

#--------------------------------
# LOAD DATA FROM A CSV FILE
#--------------------------------

#download sample point data
download.file("https://simplemaps.com/static/data/world-cities/basic/simplemaps-worldcities-basic.csv" , 
              "mypoints.csv", mode = "wb")

#read a csv file
cities<-read.csv("mypoints.csv", header=TRUE,sep=",", dec=".")

#get coordinates from cities
coorx=cities$lng
coory=cities$lat

#coordinate as matrix
coordinates<-cbind(coorx, coory)

#build a SpatialPointsDataFrame
citieslayer<-SpatialPointsDataFrame(coords=coordinates,data=cities,
                                    proj4string=CRS("+init=epsg:4326"))
#web page with a list of EPSG codes
browseURL("http://epsg.io/")

#the simpliest plot
plot(citieslayer)
#change simbol
plot(citieslayer, pch=16)
#adding axes
plot(citieslayer,pch=16, axes=TRUE)

#--------------------------------
# LOAD DATA FROM A SHP FILE
#--------------------------------

#download worl countries
download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_sovereignty.zip" , 
              "countries.zip", mode = "wb")
#unzip file
unzip("countries.zip")

#load a shapefile
countries=readOGR(dsn=getwd(), layer="ne_10m_admin_0_sovereignty")

#plot countries with axes
plot(countries, axes=TRUE)
#add citieslayer
plot(citieslayer, add=TRUE)


#a cool plot library
install.packages("ggmap")
library(ggmap)
#osm map
worldstm<-ggmap(get_map(location="Europe",zoom=3,maptype="watercolor",source="stamen"))
#plot
worldstm

#add country borders
mapcountry<-worldstm+ geom_polygon(data=fortify(countries), aes(long, lat, group=group),
                                   fill = NA, colour = "orange")
mapcountry

#add cities
mapcities<-mapcountry+geom_point(data=as.data.frame(citieslayer), aes(coorx, coory),
                                 colour = "black")
mapcities

#----------------------------
# leaflet
#----------------------------
install.packages("leaflet")
library(leaflet)

#an interactive map
mapleaflet<-leaflet() %>%
  addTiles() %>%
  addMarkers(lng = coorx, lat=coory)
mapleaflet

#adding popups
#install.packages("htmltools")
#library(htmltools)

mapleaflet<-leaflet(citieslayer) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, label = citieslayer$city)
mapleaflet

mapleaflet<-leaflet(citieslayer) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, label = paste(citieslayer$city, citieslayer$country, sep="\n"))
mapleaflet
