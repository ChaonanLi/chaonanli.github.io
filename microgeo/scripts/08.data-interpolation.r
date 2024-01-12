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

# Nearest neighbour interpolation for alpha diversity indices
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.23)
sim1 <- interp_nen(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'observed', trim.dup = TRUE) %>% 
    plot_nmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()
sim2 <- interp_nen(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'shannon', trim.dup = TRUE) %>%
    plot_nmap() %>% add_north_arrow() %>% add_scale_bar() %>% add_crs()
cowplot::plot_grid(sim1, sim2, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# 2nd polynomial fit interpolation for alpha diversity indices
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
pol.rst.observed <- interp_pol(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'observed', trim.dup = TRUE)
pol.rst.shannon  <- interp_pol(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'shannon', trim.dup = TRUE)
sim3 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = pol.rst.observed) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
sim4 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = pol.rst.shannon) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(sim3, sim4, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Inverse distance weighting (IDW) interpolation for alpha diversity indices(type = 'regular')
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
idw.rst.observed <- interp_idw(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'observed', type = 'regular', trim.dup = TRUE)
idw.rst.shannon  <- interp_idw(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'shannon', type = 'regular', trim.dup = TRUE)
sim5 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = idw.rst.observed) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
sim6 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = idw.rst.shannon) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(sim5, sim6, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Inverse distance weighting (IDW) interpolation for alpha diversity indices (type = 'hexagonal')
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.23)
sim7 <- interp_idw(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'observed', type = 'hexagonal', trim.dup = TRUE) %>%
    plot_imap() %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
sim8 <- interp_idw(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, var = 'shannon', type = 'hexagonal', trim.dup = TRUE) %>%
    plot_imap() %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(sim7, sim8, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Test models
interp_kri(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, 
           var = 'observed', model = 'Sph', test.model = TRUE, trim.dup = TRUE)
interp_kri(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, 
          var = 'shannon', model = 'Mat', test.model = TRUE, trim.dup = TRUE)

# Perform kriging interpolation for alpha diversity indices
kri.rst.observed <- interp_kri(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, 
                               var = 'observed', model = 'Sph', trim.dup = TRUE)
kri.rst.shannon <- interp_kri(map = dataset.dts.aliyun$map, met = dataset.dts.aliyun$met, dat = dataset.dts.aliyun$div$alpha, 
                              var = 'shannon', model = 'Mat', trim.dup = TRUE)

# Visualize kriging interpolation
options(repr.plot.width = 13.43 * 2, repr.plot.height = 7.9)
sim9 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = kri.rst.observed) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
sim10 <- plot_bmap(map = dataset.dts.aliyun$map) %>% add_spatraster(spat.raster = kri.rst.shannon) %>% add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(sim9, sim10, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()
