suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages() 
dataset.dts.aliyun <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                                     phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 
dataset.dts.aliyun %>% show_dataset()

# Download aridity index for research area 
dataset.dts.aliyun %<>% get_ai(out.dir = "test")

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the aridity index
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q1 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$AI, 
                   color = colorRampPalette(RColorBrewer::brewer.pal(11, "RdYlGn"))(100)) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q2 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$AI, breaks = c(0.03, 0.2, 0.5, 0.65),
                  color = RColorBrewer::brewer.pal(11, "RdYlGn")[c(1,3,5,9,11)], labels = c("HAR", "AR", "SER", "SHR", "HR")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q1, q2, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Download elevation for research area 
dataset.dts.aliyun %<>% get_elev(res = 10, out.dir = "test") 

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the elevation
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q3 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$ELEV) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q4 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$ELEV, breaks = c(3000, 4000, 5000, 6000), 
                  labels = c("<3000", "3000-4000", "4000-5000", "5000-6000", ">6000")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q3, q4, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Download 19 historically bioclimatic variables of research area
dataset.dts.aliyun %<>% get_his_bioc(res = 10, out.dir = "test")

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the Bio1 (Mean annual temperature) 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q5 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$Bio1) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q6 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$Bio1, breaks = c(-1, 0, 1), labels = c("A", "B", "C", "D")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q5, q6, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Visualize the Bio12 (Mean annual precipitation) 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q7 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$Bio12) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q8 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$Bio12, breaks = c(100, 300, 500), labels = c("<100", "100-300", "300-500", ">500")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q7, q8, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Download futrue bioclimatic variables of research area
dataset.dts.aliyun %<>% get_fut_bioc(res = 10, gcm = "ACCESS-CM2", out.dir = "test")

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the Bio1 (Mean annual temperature) of `ACCESS-CM2|ssp585|2061-2080` 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q9 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$fut$`ACCESS-CM2|ssp585|2061-2080`$Bio1) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q10 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$fut$`ACCESS-CM2|ssp585|2061-2080`$Bio1, breaks = c(-1, 0, 1), labels = c("A", "B", "C", "D")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q9, q10, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Visualize the Bio12 (Mean annual precipitation) of `ACCESS-CM2|ssp585|2061-2080` 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q11 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$fut$`ACCESS-CM2|ssp585|2061-2080`$Bio12) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q12 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
   add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$fut$`ACCESS-CM2|ssp585|2061-2080`$Bio12, breaks = c(100, 300, 500), labels = c("<100", "100-300", "300-500", ">500")) %>% 
   add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q11, q12, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Show all avaliable numeric MODIS metrics
show_modis_num_metrics()

# Download numeric metrics from MODIS
# Please provide correct username and password. Run `?get_modis_num_metrics()` to see more details.
dataset.dts.aliyun %<>% get_modis_num_metrics(username = "username", password = "password", 
                                              date.ran = c("2019-08-01|2019-09-01", "2020-08-01|2020-09-01"),
                                              measures = c("NDVI", "EVI"), out.dir = "test")

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the NDVI and EVI 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q13 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$NDVI) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q14 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$EVI) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q13, q14, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Show all avaliable classification metrics
show_modis_cla_metrics()

# Download classification metrics from MODIS
# Please provide correct username and password. Run `?get_modis_num_metrics()` to see more details.
dataset.dts.aliyun %<>% get_modis_cla_metrics(username = "username", password = "password", 
                                              measures = "LC_Type1", out.dir = "test") 

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Subset classification. Due to the high data resolution, it is not recommended to use `add_crs()` for visualization here. Otherwise, it may take a very long time.
options(repr.plot.width = 16.4, repr.plot.height = 8.02)
g.spat.raster <- subset_cla_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$cla$LC_Type1, use.class = c(10, 16)) # Only display grassland and barren
plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = g.spat.raster, color = c("darkgreen", "brown"))

# Download soil metrics from the SoilGRIDS for the research region
dataset.dts.aliyun %<>% get_soilgrid(depth = 5, measures = c("phh2o", "soc"), out.dir = "test") 

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the phh2o and soc
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q15 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$phh2o) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q16 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$soc) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q15, q16, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Process soil metrics of CHINA for a research area
# You should download the .nc files, and then place theme into `test/soilchina_products` before run `get_soilcn()`
dataset.dts.aliyun %<>% get_soilcn(depth = 0.045, measures = c("PH", "SOM"), out.dir = "test") 

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Visualize the PH and SOM 
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
q17 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$PH) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
q18 <- plot_bmap(map = dataset.dts.aliyun$map) %>%
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$SOM) %>% 
    add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(q17, q18, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Show spatial variable names in the dataset before the extraction 
dataset.dts.aliyun %<>% get_spa_vars()
head(dataset.dts.aliyun$spa$unit)

# Extract spatial data for samples
dataset.dts.aliyun %<>% extract_data_from_spatraster() %>% suppressWarnings() # A data.frame of historically spatial variables for each sample is avaliable at `dataset.dts.aliyun$spa$tabs`
head(dataset.dts.aliyun$spa$tabs)

# Check sample numbers 
dim(dataset.dts.aliyun$spa$tabs)

# Finally, we tidy up the dataset again 
dataset.dts.aliyun %<>% rarefy_count_table()
dataset.dts.aliyun %<>% tidy_dataset()
dataset.dts.aliyun %>% show_dataset()
