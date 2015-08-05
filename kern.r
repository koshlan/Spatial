# Spatial Vignette 1: Kern County

# As an environmental scientist, 
# I am fascinated by spatial data, natural resource use, and
# trying to better understand 
# the consequences of human activities on environmental quality. 

# In this vignette, I explore the expansion of almonds
# in Kern Country, CA from 2010 to 2014. 

# The expansion of almonds and other high-value woody perennial crops, 
# such as pistachios and walnuts, has been well documented by local and 
# national media outlets covering the California Drought; 
# however, I am interested in two basic land-use questions:

# First, what is the plausible net effect on irrigation of nut tree expansion.
# Obviouslly these crops need water, but what were the prior-uses and 
# associated water demand of the lands converted to new Almond orchards. 

# Second, what associations may exist between agricultural conversions 
# and pesticide use. 

# Finally what portions of Kern county are most likely to be further converted to 
# future nut orchards.

library(raster)
library(maptools)
# geotiff crop data from 2 years in Kern County, CA  (USDA Cropscape)
kern2010 <- raster("/Users/koshlan/Dropbox/KernCounty/CDL_2010_06029.tif")
kern2014 <- raster("/Users/koshlan/Dropbox/KernCounty/CDL_2014_06029.tif")

# Contextualizing Kern county in Southern California
states <- readShapePoly("/Users/koshlan/Dropbox/KernCounty/cb_2013_us_state_20m/cb_2013_us_state_20m.shp", proj4string=CRS("+proj=longlat"))
california <- states[states$STATEFP == "06",]
california.spT <- spTransform(california, CRS(proj4string(kern2000)))
plot(california.spT, col=NA, border="black")
plot(kern2000, add= TRUE)


# In 2015, Kern County published a shapefile of current agricultural boundaries.

# Projection string:
"+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 no_defs"

# NAD_1983_StatePlane_California_V_FIPS_0405_Feet
# Projection:  Lambert_Conformal_Conic
# False_Easting:	6561666.66666667
# False_Northing:	1640416.66666667
# Central_Meridian:	-118.00000000
# Standard_Parallel_1:	34.03333333
# Standard_Parallel_2:	35.46666667
# Latitude_Of_Origin:	33.50000000
# Linear Unit:	Foot_US
# Geographic Coordinate System:	GCS_North_American_1983
# Datum:	D_North_American_1983
# Prime Meridian:	Greenwich
# Angular Unit:	Degree
# plot(kern2014, add= TRUE)
kern <- readShapePoly("/Users/koshlan/Dropbox/KernCounty/kern2014/kern2014.shp")
kern <- spTransform(kern, CRS(proj4string(kern2014)))
plot(kern2000)
plot(kern, add = TRUE, col=NA, border="white")




