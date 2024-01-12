suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# Example by using the map downloaded from the DataV.GeoAtlas
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages() # head(map@data)
dataset.dts.aliyun <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                                     phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 

# Example by using the map loaded from a local ESRI Shapefile
data(qtp)
qtp.map <- system.file("shapefiles/qtp-map", "DBATP_Polygon.shp", package = "microgeo") %>% read_shp_map() %>% suppressMessages()
qtp.map@data$NAME <- "Qinghai-Tibet Plateau" 
qtp.map %<>% trans_map_fmt(var = 'NAME') # head(qtp.map@data)
dataset.dts.qtp <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = qtp.map,
                                  phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 

# Show the summary of dataset 
dataset.dts.aliyun %>% show_dataset() 
# dataset.dts.qtp %>% show_dataset()

# First example 
check.rst1 <- dataset.dts.aliyun$map %>% check_map_area(met = dataset.dts.aliyun$met, lon = 'longitude', lat = 'latitude')
head(check.rst1) # it is expected to be 0 row for this test dataset

# Second example 
check.rst2 <- dataset.dts.qtp$map %>% check_map_area(met = dataset.dts.qtp$met, lon = 'longitude', lat = 'latitude')
head(check.rst2) # it is expected to be 3 rows for this test dataset

# Plot a map to show the position of these samples on map [Second example]
# See the tutorial about visualization for more details
options(repr.plot.width = 8 * 1.5, repr.plot.height = 6 * 1.5)
dataset.dts.qtp$map %>% plot_bmap() %>% add_sampl_site(met = check.rst2, point.size = 8) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
# Three samples locate on the boundary of map
# Thus, we can ignore the warnings during creating microgeo dataset, if we use the current map.
# However, if you plan to merge some microbial traits with this map or extact a metadata table from this map, these three samples would be automatically removed！

# Show the summary of dataset before the rarefying
dataset.dts.aliyun %>% show_dataset() 

# Resample the count table 
dataset.dts.aliyun %<>% rarefy_count_table()

# Show the summary of dataset after the rarefying
# We randomly rarefied to 5310 sequences for each sample
dataset.dts.aliyun %>% show_dataset() 

# Tidy up a microgeo dataset 
dataset.dts.aliyun %<>% tidy_dataset()
if (length(unique(rownames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$ant))) > 1 || 
    !unique(rownames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$ant))) {
    stop('error-1')
}
if (length(unique(colnames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$met))) > 1 || 
    !unique(colnames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$met))) {
    stop('error-2')
}
if (length(unique(colnames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$env))) > 1 || 
    !unique(colnames(dataset.dts.aliyun$mat) == rownames(dataset.dts.aliyun$env))) {
    stop('error-3')
}
