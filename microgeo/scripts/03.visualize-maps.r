suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# The class of `common.map.mean`
data(common.map.mean)
class(common.map.mean)

# The `common.map.mean` is a microgeo-compatible `SpatialPolygonsDataFrame`
head(common.map.mean@data[,1:12])

# Change the name of Polygons
common.map.mean$NAME <- c("Tibet", "Qinghai", "Sichuan") 
head(common.map.mean@data[,1:12]) %>% suppressMessages()

# Plot a basic map without any fill color 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p1 <- common.map.mean %>% plot_bmap(legend.position = c(0.06, 0.25)) %>% suppressMessages())

# Plot a basic map with the naive polygons filled by the automatically generated colors based on a character variable
# The fill colors are randomly generated
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p2 <- common.map.mean %>% plot_bmap(var = 'NAME', fill = 'auto', legend.position = c(0.06, 0.25)))

# Plot a basic map with the naive polygons filled by the automatically generated colors based on a numeric variable
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p3 <- common.map.mean %>% plot_bmap(var = 'shannon_mean', fill = 'auto', legend.position = c(0.06, 0.255)))

# Plot a basic map with the naive polygons filled by manually set colors based on a character variable
# The display order of polygon names are also manually set
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p4 <- common.map.mean %>% plot_bmap(var = 'NAME', fill = RColorBrewer::brewer.pal(8, "Set2")[1:3], 
                                     ord = c('Tibet', 'Sichuan', 'Qinghai'), legend.position = c(0.06, 0.25)))

# Plot a basic map with the naive polygons filled by manually set colors based on a numeric variable
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p5 <- common.map.mean %>% plot_bmap(var = 'shannon_mean', fill = colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG"))(100), 
                                     legend.position = c(0.06, 0.255)))

# The class of `gridded.map.mean`
data(gridded.map.mean) 
class(gridded.map.mean)

# The `gridded.map.mean` is a microgeo-compatible `SpatialPolygonsDataFrame`
# The `NA` means that there are no samples in the grid. The `NAME` means the grid ID.
head(gridded.map.mean@data[,1:12])

# Plot a gridded map without any fill color 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p6 <- gridded.map.mean %>% plot_bmap(legend.position = c(0.06, 0.25)))

# Plot a gridded map with the grids filled by the automatically generated colors based on a numeric variable
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p7 <- gridded.map.mean %>% plot_bmap(var = 'shannon_mean', fill = 'auto', legend.position = c(0.06, 0.255)))

# Plot a gridded map with the grids filled by manually set colors based on a numeric variable
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p8 <- gridded.map.mean %>% plot_bmap(var = 'shannon_mean', fill = rev(colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG"))(100)),
                                      legend.position = c(0.06, 0.255)))

# The `nen.interp` is a list
data(nen.interp)
class(nen.interp)

# There are two dataset in `nen.interp` 
names(nen.interp)

# Plot a map for the results of nearest neighbour interpolation [alpha diversity ==> observed] 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p9 <- nen.interp$observed %>% plot_nmap(legend.position = c(0.06, 0.25)))

# Plot a map for the results of nearest neighbour interpolation [alpha diversity ==> shannon]; Use manually set colors
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p10 <- nen.interp$shannon %>% plot_nmap(fill = colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG"))(100), legend.position = c(0.06, 0.255)))

# The `idw.interp.hex` is a list
data(idw.interp.hex)
class(idw.interp.hex)

# There are two dataset in the `idw.interp.hex`
names(idw.interp.hex)

# Plot a map for the results of inverse distance weighting (IDW) interpolation [alpha diversity ==> observed] 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p11 <- idw.interp.hex$observed %>% plot_imap(legend.position = c(0.06, 0.255)))

# Plot a map for the results of inverse distance weighting (IDW) interpolation [alpha diversity ==> shannon]; Use manually set colors
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p12 <- idw.interp.hex$shannon %>% plot_imap(fill = colorRampPalette(RColorBrewer::brewer.pal(11, "BrBG"))(100), legend.position = c(0.06, 0.255)))

# Add the NAME of grid on the map
options(repr.plot.width = 15.4 * 2, repr.plot.height = 8.02)
p13 <- p6 %>% add_label(dat = gridded.map.mean@data, lab.var = 'NAME', lon.var = 'X.CENTER', 
                        lat.var = 'Y.CENTER', size = 5, remove.na = FALSE) # show all grid names 
p14 <- p6 %>% add_label(dat = gridded.map.mean@data, lab.var = 'NAME', lon.var = 'X.CENTER', 
                        lat.var = 'Y.CENTER', size = 5, remove.na = TRUE) # only show the names of grid covered by field sampling 
cowplot::plot_grid(p13, p14, align = 'hv', ncol = 2, label_size = 28, labels = c("a", "b")) %>% suppressWarnings()

# Add the names of naive polygons and sample number in each naive polygon onto the map 
options(repr.plot.width = 15.4, repr.plot.height = 8.02 * 3)
p15 <- p4 %>% 
    add_label(dat = common.map.mean@data, lab.var = 'NAME', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5) %>% 
    add_label(dat = common.map.mean@data, lab.var = 'sample.num', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5, vjust = 3) %>% suppressWarnings()

# Add the sample number of each grid onto the map
p16 <- p7 %>% add_label(dat = gridded.map.mean@data, lab.var = 'sample.num', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5, remove.na = F)

# Add the standard errors of shannon index in each grid on the map 
# Grids without labels mean that the samples are not enough for the calculation of standard error (at least two samples are required)
p17 <- p7 %>% add_label(dat = gridded.map.mean@data, lab.var = 'shannon_se', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5, remove.na = F) 

# Display the figure
cowplot::plot_grid(p15, p16, p17, align = 'hv', ncol = 1, label_size = 28, labels = c("a", "b", "c")) %>% suppressWarnings()

# Add points onto a gridded map by using the standard error of shannon index in each grid
# Grids without point mean that the samples are not enough for the calculation of standard error (at least two samples are required)
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p18 <- p7 %>% add_point(dat = gridded.map.mean@data, lab.var = 'shannon_se', 
                              lon.var = "X.CENTER", lat.var = "Y.CENTER", remove.na = TRUE) )# Remove all NA

# Create a microgeo dataset. See subsequent tutorial for details. 
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000))
dataset.dts <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map, 
                              phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude")
dataset.dts %<>% tidy_dataset() 

# Visualize the soil pH of each sampling site onto maps
options(repr.plot.width = 15.4 * 2, repr.plot.height = 8.02 * 3)
dat <- cbind(dataset.dts$met, dataset.dts$env)
p19 <- p1  %>% add_point(dat = dat, lab.var = 'pH') 
p20 <- p1  %>% add_point(dat = dat, lab.var = 'pH', fill = 'lightblue') 
p21 <- p1  %>% add_point(dat = dat, lab.var = 'pH', fill = rev(colorRampPalette(RColorBrewer::brewer.pal(11, 'RdYlGn'))(100)))
p22 <- p7  %>% add_point(dat = dat, lab.var = 'pH') 
p23 <- p9  %>% add_point(dat = dat, lab.var = 'pH')
p24 <- p11 %>% add_point(dat = dat, lab.var = 'pH')
cowplot::plot_grid(p19, p20, p21, p22, p23, p24, align = 'hv', ncol = 2, label_size = 28, 
                   labels = c("a", "b", "c", "d", "e", "f")) %>% suppressWarnings()

# Create a microgeo dataset. See subsequent tutorial for details. 
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000))
dataset.dts <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                              phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 

# Download phh2o from soilgrid database.
dataset.dts %<>% get_soilgrid(depth = 5, measures = c('phh2o'), out.dir = "test") 

# Add the SpatRaster data of soil pH onto a map 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
(p25 <- p1 %>% add_spatraster(spat.raster = dataset.dts$spa$rast$his$phh2o))

# Download classification MODIS metrics of research region. 
# Please provide correct username and password. Run `?get_modis_cla_metrics()` to see more details.
dataset.dts %<>% get_modis_cla_metrics(username = "username", password = "password", out.dir = "test") 

# Mask the results by using grassland(10); Run `?get_modis_cla_metrics()` to see more details.
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
m1 <- mask_spatraster_by_cla(tar.spat = dataset.dts$spa$rast$his$phh2o, ref.spat = dataset.dts$spa$rast$cla$LC_Type1, use.class = 10)
(p26 <- p1 %>% add_spatraster(spat.raster = m1))

# Mask the results by using barren(16); Run `?get_modis_cla_metrics()` to see more details.
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
m2 <- mask_spatraster_by_cla(tar.spat = dataset.dts$spa$rast$his$phh2o, ref.spat = dataset.dts$spa$rast$cla$LC_Type1, use.class = 16)
(p27 <- p1 %>% add_spatraster(spat.raster = m2))

# Mask the results by using forest (1,2,3,4,5); Run `?get_modis_cla_metrics()` to see more details.
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
m3 <- mask_spatraster_by_cla(tar.spat = dataset.dts$spa$rast$his$phh2o, ref.spat = dataset.dts$spa$rast$cla$LC_Type1, use.class = c(1,2,3,4,5))
(p28 <- p1 %>% add_spatraster(spat.raster = m3))

# Mask the results by using grassland (10) and barren (16); Run `?get_modis_cla_metrics()` to see more details.
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
m4 <- mask_spatraster_by_cla(tar.spat = dataset.dts$spa$rast$his$phh2o, ref.spat = dataset.dts$spa$rast$cla$LC_Type1, use.class = c(10, 16))
(p29 <- p1 %>% add_spatraster(spat.raster = m4))

# Create a microgeo dataset. See subsequent tutorial for details. 
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000))
dataset.dts <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                              phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 
dataset.dts %<>% rarefy_count_table() 
dataset.dts %<>% tidy_dataset()
dataset.dts %<>% calc_alpha_div(measures = c("observed", "shannon"))

# Perform kriging interpolation for shannon diversity indices.
kri.rst.shannon <- interp_kri(map = dataset.dts$map, met = dataset.dts$met, dat = dataset.dts$div$alpha, 
                              var = 'shannon', model = 'Mat', trim.dup = TRUE) %>% suppressMessages()

# Add contours on the map 
options(repr.plot.width = 15.4 * 2, repr.plot.height = 8.02)
p30 <- p1 %>% add_contour(spat.raster = kri.rst.shannon, nlevels = 100)
p31 <- p1 %>% add_spatraster(spat.raster = kri.rst.shannon) %>% add_contour(spat.raster = kri.rst.shannon, nlevels = 10, color = 'white', show.labels = TRUE)
cowplot::plot_grid(p30, p31, align = 'hv', ncol = 2, label_size = 28, labels = c("a", "b")) %>% suppressWarnings()

# Add a north arrow on the map
options(repr.plot.width = 15.4 * 2, repr.plot.height = 8.02)
p32 <- p29 %>% add_north_arrow() %>% suppressWarnings()
p33 <- p30 %>% add_north_arrow() %>% suppressWarnings()
cowplot::plot_grid(p32, p33, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Add a spatial-aware scale bar on the map
options(repr.plot.width = 15.4 * 2, repr.plot.height = 8.02)
p34 <- p32 %>% add_scale_bar()
p35 <- p33 %>% add_scale_bar()
cowplot::plot_grid(p34, p35, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings() %>% suppressMessages()

# Add a coordinate reference system to the map before final visualization
options(repr.plot.width = 13.4 * 2, repr.plot.height = 8.02)
p36 <- p34 %>% add_crs()
p37 <- p35 %>% add_crs()
cowplot::plot_grid(p36, p37, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings() %>% suppressMessages()

# Create a microgeo dataset. See subsequent tutorial for more details.
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000))
dataset.dts <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                              phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 
dataset.dts %<>% get_his_bioc(res = 10, out.dir = "test") 
dataset.dts %<>% get_soilgrid(depth = 5, measures = c('phh2o'), out.dir = "test") 
dataset.dts %<>% get_ai(out.dir = "test") # To address the error of `b56e9b573aafae51462e': Timeout of 60 seconds was reached`, run `options(timeout=60000)`
dataset.dts %<>% extract_data_from_spatraster(type = 'his') 
dataset.dts %<>% tidy_dataset()

# Add two grouping variable in `dataset.dts$met`
dataset.dts$met$GA <- cut(dataset.dts$spa$tabs$AI, breaks = c(-Inf, 0.2, 0.5, Inf), labels = c("A1", "B1", "C1"))
dataset.dts$met$GM <- cut(dataset.dts$spa$tabs$Bio1, breaks = c(-Inf, -1, 1, Inf), labels = c("A2", "B2", "C2"))

# Add sampling sites without colors 
options(repr.plot.width = 13.4 * 2, repr.plot.height = 8.02 * 3)
s1 <- p4 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s2 <- p7 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s3 <- p11 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s4 <- p9 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s5 <- p25 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s6 <- p29 %>% add_sampl_site(met = dataset.dts$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    suppressWarnings() %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(s1, s2, s3, s4, s5, s6, align = 'hv', ncol = 2, labels = c("a", "b", "c", "d", "e", "f"), label_size = 28) %>% suppressWarnings()

# Add sampling sites with color and shapes [on basic map]
options(repr.plot.width = 13.4 * 2, repr.plot.height = 8.02)
s7 <- p1 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", color.val = "gray30",point.alpha = 0.5) %>%  
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
s8 <- p1 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", shape.var = "GA", color.val = "gray30", point.alpha = 0.5) %>%
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(s7, s8, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Facet by one grouping variable
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9 * 3)
s9 <- p1 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", shape.var = "GA", color.val = "gray30", point.alpha = 0.5, facet.by.color = T, facet.col.nums = 1) %>%
      add_scale_bar() %>% add_north_arrow() %>% add_crs()
s10 <- p29 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", shape.var = "GA", color.val = "gray30", point.alpha = 0.5, facet.by.color = T, facet.col.nums = 1) %>%
       add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(s9, s10, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Facet by two grouping variables [on basic map]
options(repr.plot.width = 13.43 * 3, repr.plot.height = 7.23 * 3)
p1 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", shape.var = "GM", color.val = "gray30", point.alpha = 0.5, facet.by.color = T, facet.by.shape = T) %>%
       add_scale_bar() %>% add_north_arrow() %>% add_crs()

# Facet by two grouping variables [on SpatRaster]
options(repr.plot.width = 13.43 * 3, repr.plot.height = 7.9 * 3)
p29 %>% add_sampl_site(met = dataset.dts$met, color.var = "GA", shape.var = "GM", color.val = "gray30", point.alpha = 0.5, facet.by.color = T, facet.by.shape = T) %>%
        add_scale_bar() %>% add_north_arrow() %>% add_crs()
