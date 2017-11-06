#-------------------------------------------
#WORKSHOP GEOMUNDUS 2017 MUNSTER 11/11/2017
# create and save spatial data
#-------------------------------------------

#To understand whats going on execute line by line

#--------------------------------
# SET UP R ENVIRONMENT
#--------------------------------

#Load libraries, install.packages("rgdal","sp", "leaflet")
library(rgdal)
library(sp)
library(leaflet)

#Set working directory to your file location
# Rstudio Session>>Set Working directory>>to source file location
setwd("/geomundus2017")

#-----------------------------------
# points data frames
#------------------------------------

#Create a matrix with the coordinates
#------------------------------------

#coordinates as vector
coor1=c(48,0)
coor2=c(48.5,0)

#coordinate as matrix
coordinates=rbind(coor1, coor2)

# data for each coordinate
#-----------------------------
mydata=as.data.frame(rbind("point1", "point1"))

#Corrdinate reference system
#----------------------------
#There are to options todefine de CRS
#visit http://spatialreference.org/ref/epsg/wgs-84/

#just with the epsg code
myCRS=CRS("+init=epsg:4326")
#proj4 (recomended)
myCRS=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


#built my SpatialPointsDataFrame
#--------------------------------------

mypoints=SpatialPointsDataFrame(coords=coordinates,data=mydata, proj4string = myCRS)

plot(mypoints, axes=TRUE)

# export to shape
writeOGR(mypoints, dsn="myfolder", layer="mypoints", driver="ESRI Shapefile")

#Write GeoJSON
writeOGR(mypoints,"test_name.json",layer="whatever", driver="GeoJSON")

#write kml
writeOGR(mypoints,"test_name.kml",layer="whatever", driver="KML")


#-----------------------------------
# lines
#-----------------------------------
#get bounding box as a polygon
#build coordinates
coor1=c(-0.1644,39.8485)
coor2=c(-0.1644, 40.0034)
coor3=c(0.6916, 40.0034)
coor4=c(0.6916 , 39.8485)

mycoor=rbind(coor4,coor3,coor2,coor1)
             
coorline=mycoor

#build a line
myline=Line(coorline)
#get all the lines together
mylines=Lines(myline, "road")
#built data frame
mylinedat=SpatialLines(list(mylines), proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

plot(mylinedat, axes=TRUE)

#-----------------------------------
# polygon
#-----------------------------------

# you need to make sure that the last point and first coincide,
coorbox=rbind(mycoor, mycoor[1,])

#build polygon
#build a dingle poligon
mypol<-Polygon(coorbox)
#get all the poligons together
mypols<-Polygons(list(mypol), "ring") #ring is the name of the polygon
#built data frame
mypoldat=SpatialPolygons(Srl=list(mypols), proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

plot(mypoldat, axes=TRUE)



