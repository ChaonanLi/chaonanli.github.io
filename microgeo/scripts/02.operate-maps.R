suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# Read the map of Xizang, Qinghai and Sichuan
# The `read_aliyun_map()` returns a microgeo-compatible and reliable SpatialPolygonsDataFrame
# There are Chinese characters in the `SpatialPolygonsDataFrame` returned by `read_aliyun_map()`
map2 <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages()
head(map2@data)

# change the `NAME` to Pinyin if you plan to publish the map on an international journal
map2@data$NAME <- c("Tibet", "Qinghai", "Sichuan")
head(map2@data)

# Plot the map of Xizang, Qinghai and Sichuan
options(repr.plot.width = 13.43, repr.plot.height = 7.23)
map2 %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Read the map of Australia
map <- read_gadm_map(iso = 'Australia', out.dir = 'test') 
head(map@data)

# Convert the non-standardized `SpatialPolygonsDataFrame` to a microgeo-compatible one
map %<>% trans_map_fmt(var = 'NAME_1')
head(map@data)

# Visualize the map of Australia
options(repr.plot.width = 9, repr.plot.height = 7.23)
map %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Read the map of Washington State, USA
map <- read_gadm_map(iso = 'USA', out.dir = 'test')
head(map@data)

# Get the areas of Washington, USA
map %<>% terra::subset(map$NAME_1 == 'Washington')
head(map@data)

# Convert the non-standardized `SpatialPolygonsDataFrame` to a microgeo-compatible one
map %<>% trans_map_fmt(var = 'NAME_1') # only use the map of Washington, USA
head(map@data)

# Visualize the map of Washington State, USA
options(repr.plot.width = 9, repr.plot.height = 7.23)
map %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Read original China map from local shapefiles
cn.map <- system.file("shapefiles/china-map", "china.shp", package = "microgeo") %>% read_shp_map() %>% suppressMessages() 
head(cn.map@data)

# Get the areas of Xizang, Qinghai and Sichuan
cn.map.sub <- terra::subset(cn.map, cn.map$FENAME %in% c("Xizang Zizhiqu", "Qinghai Sheng", "Sichuan Sheng")) 
head(cn.map.sub@data)

# Convert the non-standardized `SpatialPolygonsDataFrame` to a microgeo-compatible one
cn.map.sub %<>% trans_map_fmt(var = 'FENAME')
head(cn.map.sub@data)

# Plot the map of Xizang, Qinghai and Sichuan
options(repr.plot.width = 13.43, repr.plot.height = 7.23)
cn.map.sub %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Read the original map of Qinghai-Tibet Plateau (QTP)
qtp.map <- system.file("shapefiles/qtp-map", "DBATP_Polygon.shp", package = "microgeo") %>% read_shp_map() 
head(qtp.map@data)

# Add a column to meet the demands of `trans_map_fmt() ` function
qtp.map@data$NAME <- "Qinghai-Tibet Plateau"
head(qtp.map@data)

# Convert the non-standardized `SpatialPolygonsDataFrame` to a microgeo-compatible one
qtp.map %<>% trans_map_fmt(var = 'NAME')
head(qtp.map@data) 

# Plot the map of Qinghai-Tibet Plateau
options(repr.plot.width = 10, repr.plot.height = 7.23)
qtp.map %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Read the map areas from local shapefiles
cn.map <- system.file("shapefiles/china-map", "china.shp", package = "microgeo") %>% read_shp_map() 
cn.map.sub <- terra::subset(cn.map, cn.map$FENAME %in% c("Xizang Zizhiqu", "Qinghai Sheng", "Sichuan Sheng")) 
head(cn.map.sub@data)

# Convert the format of SpatialPolygonsDataFrame
cn.map.sub %<>% trans_map_fmt(var = 'FENAME')
head(cn.map.sub@data)

# Read map from the DataV.GeoAtlas (`http://datav.aliyun.com/portal/school/atlas/area_selector`)
map <- read_aliyun_map(adcode = c("540000", "630000", "510000"))
head(map@data)

# Grid the map using a spatial resolution of 1.5 degree
gridded.map <- grid_map(map = map, res = 1.5) %>% suppressMessages()
head(gridded.map@data)

# Plot the gridded map without grid names
options(repr.plot.width = 13.43, repr.plot.height = 7.23)
gridded.map %>% plot_bmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()

# Plot the gridded map with grid names
options(repr.plot.width = 13.43, repr.plot.height = 7.23)
gridded.map %>% plot_bmap() %>% 
    add_label(dat = gridded.map@data, lab.var = "NAME", lon.var = "X.CENTER", lat.var = "Y.CENTER", size = 5.5) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
