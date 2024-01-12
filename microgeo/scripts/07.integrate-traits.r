suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# Use the map downloaded from DataV.GeoAtlas
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages() 
dataset.dts.aliyun <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                                     phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude")
dataset.dts.aliyun %<>% rarefy_count_table()
dataset.dts.aliyun %<>% tidy_dataset()
dataset.dts.aliyun %<>% calc_alpha_div(measures = c("observed", "shannon")) 
dataset.dts.aliyun %<>% calc_beta_div(measures = c("bray", "jaccard")) 
dataset.dts.aliyun %>% show_dataset()

# Check the data.frame of alpha diversity indices 
head(dataset.dts.aliyun$div$alpha)

# Check the `SpatialPolygonsDataFrame`
head(dataset.dts.aliyun$map@data)

# Change the names of Polygons
dataset.dts.aliyun$map@data$NAME <- c("Tibet", "Qinghai", "Sichuan") 
head(dataset.dts.aliyun$map@data)

# Merge data to a `SpatialPolygonsDataFrame`
common.map.mean4df <- merge_dfs_to_map(map = dataset.dts.aliyun$map, dat = dataset.dts.aliyun$div$alpha, 
                                       met = dataset.dts.aliyun$met, med = 'mean')
head(common.map.mean4df@data[,1:12])
# Now, you can visualize the microbial traits (alpha diversity indices) onto a map

# Grid the map [`SpatialPolygonsDataFrame`]
gridded.map <- grid_map(map = dataset.dts.aliyun$map, res = 1.5) %>% suppressMessages
head(gridded.map@data)

# Merge data to a gridded map
gridded.map.mean4df <- merge_dfs_to_map(map = gridded.map, dat = dataset.dts.aliyun$div$alpha, 
                                        met = dataset.dts.aliyun$met, med = 'mean')
head(gridded.map.mean4df@data[,1:12])
# Now, you can visualize the microbial traits (alpha diversity indices) onto a map

# Check the distance matrix 
dataset.dts.aliyun$div$beta$bray[1:5, 1:5]

# Check the `SpatialPolygonsDataFrame`
head(dataset.dts.aliyun$map@data)

# Merge distance matrix to a common map
common.map.mean4mx <- merge_mtx_to_map(map = dataset.dts.aliyun$map, dat = dataset.dts.aliyun$div$beta$bray, 
                                        met = dataset.dts.aliyun$met, var = 'bray', med = 'mean')
head(common.map.mean4mx@data[,1:9])
# Now, you can visualize the microbial traits (beta diversity distance matrix) onto a map

# Grid the map 
gridded.map <- grid_map(map = dataset.dts.aliyun$map, res = 1.5) %>% suppressMessages
head(gridded.map@data)

# Merge distance matrix to a gridded map
gridded.map.mean4mx <- merge_mtx_to_map(map = gridded.map, dat = dataset.dts.aliyun$div$beta$bray, 
                                        met = dataset.dts.aliyun$met, var = 'bray', med = 'mean')
head(gridded.map.mean4mx@data[,1:9])
# Now, you can visualize the microbial traits (beta diversity distance matrix) onto a map

# Extract metadata from a common map
# Rownames are sample IDs
# This new matadata table can be used for subsequent statistical analysis
metadata <- dataset.dts.aliyun$map %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata)

# Extract metadata from a common map with additional data
# Rownames are sample IDs
# This new matadata table can be used for subsequent statistical analysis 
metadata.from.c.df <- common.map.mean4df %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata.from.c.df)

# Extract metadata from a gridded map
# Rownames are sample IDs
# This new matadata table can be used for subsequent statistical analysis
metadata.from.g.mx <- gridded.map.mean4mx %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata.from.g.mx)
