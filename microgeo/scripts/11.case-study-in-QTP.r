# Load required R packages 
suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

# A function for saving figure into PDF file
savePDF = function(object, path, filename, width = 16.4, height = 8.02){
    pdf(file.path(path, filename), width = width, height = height)
        object %>% print() %>% suppressWarnings() %>% suppressMessages()
    dev.off()
}

# Output directory for this case study
outpath <- "test/case_study"
if (!dir.exists(outpath)) dir.create(path = outpath, recursive = T)

dataset <- readRDS("../dev/dat/rawdata/qtp-bac-rawdata/qtp-16S-stats-dataset-2022-04-01.Rds")
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages()
dataset.dts.aliyun <- create_dataset(mat = dataset$unresampled$asv, ant = dataset$unresampled$tax, 
                                     met = dataset$unresampled$met, map = map, lon = "longitude", lat = "latitude") 

dataset.dts.aliyun %>% show_dataset()

dataset.dts.aliyun %<>% get_elev(res = 2.5, out.dir = "test") 
dataset.dts.aliyun %<>% get_his_bioc(res = 2.5, out.dir = "test")
dataset.dts.aliyun %<>% get_fut_bioc(res = 2.5, out.dir = "test", yea = c("2021-2040", "2081-2100"))
dataset.dts.aliyun %<>% get_modis_cla_metrics(username = "username", password = "password", measures = "LC_Type1", out.dir = "test") 

dataset.dts.aliyun %>% show_dataset()

dataset.dts.aliyun %<>% extract_data_from_spatraster()
head(dataset.dts.aliyun$spa$tabs)

dataset.dts.aliyun %<>% rarefy_count_table(depth = 5000)

dataset.dts.aliyun %<>% tidy_dataset()
dataset.dts.aliyun %>% show_dataset()

options(repr.plot.width = 13.5/1.5, repr.plot.height = 8.02/1.5)
(p.samp.map <- dataset.dts.aliyun$map %>% 
    plot_bmap(legend.position = c(0.0575, 0.25)) %>% 
    add_spatraster(spat.raster = dataset.dts.aliyun$spa$rast$his$ELEV) %>% 
    add_sampl_site(met = dataset.dts.aliyun$met, color.val = "gray30", fill.val = "white", point.alpha = 0.5) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs())
saved <- savePDF(object = p.samp.map, path = outpath, filename = "sampling-site-map.pdf", width = 13.5/1.5, height = 8.02/1.5)

# Combines the historical and future Bio1 to one SpatRaster.
his.bio1 <- dataset.dts.aliyun$spa$rast$his$Bio1
ssp126.2021to2040.bio1 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2021-2040`$Bio1
ssp126.2081to2100.bio1 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2081-2100`$Bio1
ssp585.2021to2040.bio1 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2021-2040`$Bio1
ssp585.2081to2100.bio1 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2081-2100`$Bio1
all.bio1 <- c(his.bio1              , his.bio1, 
              ssp126.2021to2040.bio1, ssp585.2021to2040.bio1, 
              ssp126.2081to2100.bio1, ssp585.2081to2100.bio1)
names(all.bio1) <- c("Historical"      , "Historical.dup", 
                     "SSP126|2021-2040", "SSP585|2021-2040",
                     "SSP126|2081-2100", "SSP585|2081-2100")

# Combines the historical and future Bio12 to one SpatRaster.
his.bio12 <- dataset.dts.aliyun$spa$rast$his$Bio12
ssp126.2021to2040.bio12 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2021-2040`$Bio12
ssp126.2081to2100.bio12 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2081-2100`$Bio12
ssp585.2021to2040.bio12 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2021-2040`$Bio12
ssp585.2081to2100.bio12 <- dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2081-2100`$Bio12
all.bio12 <- c(his.bio12              , his.bio12, 
               ssp126.2021to2040.bio12, ssp585.2021to2040.bio12, 
               ssp126.2081to2100.bio12, ssp585.2081to2100.bio12)
names(all.bio12) <- c("Historical"      , "Historical.dup", 
                      "SSP126|2021-2040", "SSP585|2021-2040",
                      "SSP126|2081-2100", "SSP585|2081-2100")

# Visualize the bio1 (MAT). The results indicate that the QTP would be warmer in the future
options(repr.plot.width = (13.5/1.6) * 2, repr.plot.height = (8.02/1.5) * 3)
(p.his.bio1 <- dataset.dts.aliyun$map %>% 
    plot_bmap(legend.position = c(0.06, 0.25)) %>% 
    add_spatraster(spat.raster = all.bio1, facet.col.nums = 2, breaks = c(-1, 0, 1), labels = c("< -1", "-1 to 0", "0 to 1", "> 1")) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs())
saved <- savePDF(object = p.his.bio1, path = outpath, filename = "bio1.pdf", width = (13.5/1.6) * 2, height = (8.02/1.5) * 3)

# Visualize the bio12 (MAP). The results indicate that the QTP also would be wetter in the future
options(repr.plot.width = (13.5/1.6) * 2, repr.plot.height = (8.02/1.5) * 3)
(p.his.bio12 <- dataset.dts.aliyun$map %>% 
    plot_bmap(legend.position = c(0.06, 0.25)) %>% 
    add_spatraster(spat.raster = all.bio12, facet.col.nums = 2, breaks = c(100, 300, 500), labels = c("<100", "100-300", "300-500", ">500")) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs())
saved <- savePDF(object = p.his.bio12, path = outpath, filename = "bio12.pdf", width = (13.5/1.6) * 2, height = (8.02/1.5) * 3)

# Calculate the relative abundance
dataset.dts.aliyun %<>% calc_rel_abund() 
dataset.dts.aliyun %>%  show_dataset()

# Check the relative abundance
head(dataset.dts.aliyun$abd$raw$Phylum[,1:10])

# Plot bar charts for `p__Actinobacteria`
options(repr.plot.width = 5, repr.plot.height = 5)
plotdat <- data.frame(sample = rownames(dataset.dts.aliyun$abd$raw$Phylum),
                     p__Actinobacteria = dataset.dts.aliyun$abd$raw$Phylum$p__Actinobacteria, 
                     Others = 100 - dataset.dts.aliyun$abd$raw$Phylum$p__Actinobacteria) %>% reshape2::melt() %>% suppressMessages() 
(p.bar <- ggplot(plotdat, aes(x = sample, y = value)) + geom_bar(stat = 'identity', position = 'fill', aes(fill = variable), width = 1) + 
    theme_bw() + ylab("Relative abundance") + 
     geom_hline(yintercept = 0.65, linetype = 2) + 
    theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(),
          axis.title.y = element_text(size = 14), axis.text.y = element_text(size = 12)) + 
    scale_fill_manual(name = "", values = c("blue", "gray")))
(p.pie <- ggplot(plotdat, aes(x = "", y = value, fill = variable)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() + scale_fill_manual(name = "", values = c("blue", "gray")))
saved <- savePDF(object = p.bar, path = outpath, filename = "p.bar.pdf", width = 5, height = 5)
saved <- savePDF(object = p.pie, path = outpath, filename = "p.pie.pdf", width = 5, height = 5)

# A regression model 
reg <- create_ml_model(y.data = dataset.dts.aliyun$abd$raw$Phylum, 
                       x.data = dataset.dts.aliyun$spa$tabs[,paste0("Bio", seq(19))], 
                       var = "p__Actinobacteria", method = 'rf', threads = 60)

# A classification model. Here we only focused on `p__Actinobacteria`
# If the relative abundance is more than 35%, then we define such a sample as p__Actinobacteria predominated soil
phyla.bins <- data.frame(row.names = rownames(dataset.dts.aliyun$abd$raw$Phylum), 
                         p__Actinobacteria = dataset.dts.aliyun$abd$raw$Phylum$p__Actinobacteria)
phyla.bins$p__Actinobacteria <- ifelse(phyla.bins$p__Actinobacteria > 35, "predominated", "non-predominated")
table(phyla.bins$p__Actinobacteria)
phyla.bins$p__Actinobacteria <- as.factor(phyla.bins$p__Actinobacteria)
cla <- create_ml_model(y.data = phyla.bins, 
                       x.data = dataset.dts.aliyun$spa$tabs[,paste0("Bio", seq(19))],
                       var = 'p__Actinobacteria', method = 'rf', type = 'classification')

# Model performace
options(repr.plot.width = 10, repr.plot.height = 5)
p.reg.eva <- reg %>% evaluate_ml_model()
p.cla.eva <- cla %>% evaluate_ml_model()
(p.eva <- cowplot::plot_grid(p.reg.eva, p.cla.eva, align = 'hv', ncol = 2, labels = c('(a)', '(b)'), label_size = 21) %>% suppressWarnings())
saved <- savePDF(object = p.eva, path = outpath, filename = "p.eva.pdf", width = 10, height = 5)

# The map of training and testing data 
options(repr.plot.width = 13.5/1.3/2, repr.plot.height = 8.02/1.3)
new.met.reg <- dataset.dts.aliyun$met
new.met.cla <- dataset.dts.aliyun$met
new.met.reg$group <- ifelse(rownames(new.met.reg) %in% rownames(reg$train.dat), "Training", "Testing")
new.met.cla$group <- ifelse(rownames(new.met.cla) %in% rownames(cla$train.dat), "Training", "Testing")
p.map.reg <- dataset.dts.aliyun$map %>% 
    plot_bmap(legend.position = c(0.125, 0.25)) %>% 
    add_sampl_site(met = new.met.reg, color.var = "group", point.alpha = 0.2, point.size = 2) %>% add_crs()
p.map.cla <- dataset.dts.aliyun$map %>% 
    plot_bmap(legend.position = c(0.125, 0.25)) %>% 
    add_sampl_site(met = new.met.cla, color.var = "group", point.alpha = 0.2, point.size = 2) %>% add_crs()
(p.model.sampl.map <- cowplot::plot_grid(p.map.reg, p.map.cla, align = 'hv', ncol = 1, labels = c('(a)', '(b)'), label_size = 21) %>% suppressWarnings())
saved <- savePDF(object = p.model.sampl.map, path = outpath, filename = "p.model.sampl.map.pdf", width = 13.5/1.3/2, height = 8.02/1.3)

# Prepare the climate data for predictions 
climate.data <- list(
    dataset.dts.aliyun$spa$rast$his[[paste0("Bio", seq(19))]],
    dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2021-2040`,
    dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp126|2081-2100`,
    dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2021-2040`,
    dataset.dts.aliyun$spa$rast$fut$`BCC-CSM2-MR|ssp585|2081-2100`
)
names(climate.data) <- c("Historical", "SSP126|2021-2040", "SSP126|2081-2100", "SSP585|2021-2040", "SSP585|2081-2100")

# Predictions of relative abundance
bio <- list(10, 16, c(1:5)) # "Grasslands", "Barren", "Forests"
reg.pred.rst <- lapply(climate.data, function(climate) reg %>% predict_ml_geomap(spat.raster = climate))      
reg.pred.rst.masked <- lapply(reg.pred.rst, FUN = function(pre){
    inner.res <- lapply(bio, FUN = function(b){
        mask_spatraster_by_cla(tar.spat = pre, ref.spat = dataset.dts.aliyun$spa$rast$cla$LC_Type1, use.class = b)
    })
    names(inner.res) <- c("Grasslands", "Barren", "Forests")
    inner.res
})  

# Prepare visualizition data: SSP126
reg.visual.dat.ssp126 <- c(
    reg.pred.rst.masked$Historical$Grasslands        , reg.pred.rst.masked$Historical$Barren        , reg.pred.rst.masked$Historical$Forests,
    reg.pred.rst.masked$`SSP126|2021-2040`$Grasslands, reg.pred.rst.masked$`SSP126|2021-2040`$Barren, reg.pred.rst.masked$`SSP126|2021-2040`$Forests,
    reg.pred.rst.masked$`SSP126|2081-2100`$Grasslands, reg.pred.rst.masked$`SSP126|2081-2100`$Barren, reg.pred.rst.masked$`SSP126|2081-2100`$Forests
)
names(reg.visual.dat.ssp126) <- c("Historical|Grasslands", "Historical|Barren", "Historical|Forests", 
                                  "SSP126|2021-2040|Grasslands", "SSP126|2021-2040|Barren", "SSP126|2021-2040|Forests",
                                  "SSP126|2081-2100|Grasslands", "SSP126|2081-2100|Barren", "SSP126|2081-2100|Forests")

# Prepare visualizition data: SSP585
reg.visual.dat.ssp585 <- c(
    reg.pred.rst.masked$Historical$Grasslands        , reg.pred.rst.masked$Historical$Barren        , reg.pred.rst.masked$Historical$Forests,
    reg.pred.rst.masked$`SSP585|2021-2040`$Grasslands, reg.pred.rst.masked$`SSP585|2021-2040`$Barren, reg.pred.rst.masked$`SSP585|2021-2040`$Forests,
    reg.pred.rst.masked$`SSP585|2081-2100`$Grasslands, reg.pred.rst.masked$`SSP585|2081-2100`$Barren, reg.pred.rst.masked$`SSP585|2081-2100`$Forests
)
names(reg.visual.dat.ssp585) <- c("Historical|Grasslands", "Historical|Barren", "Historical|Forests", 
                                  "SSP585|2021-2040|Grasslands", "SSP585|2021-2040|Barren", "SSP585|2021-2040|Forests",
                                  "SSP585|2081-2100|Grasslands", "SSP585|2081-2100|Barren", "SSP585|2081-2100|Forests")

# Visualize the ssp126
options(repr.plot.width = 13.43*1.5, repr.plot.height = 7.9*1.5)
(p.reg.fig.ssp126 <- plot_bmap(map = dataset.dts.aliyun$map) %>% 
    add_spatraster(spat.raster = reg.visual.dat.ssp126, facet.col.nums = 3) %>% 
    add_scale_bar(size = 1.5) %>% add_north_arrow() %>%add_crs())
saved <- savePDF(object = p.reg.fig.ssp126, path = outpath, filename = "p.reg.fig.ssp126.pdf", width = 13.43*1.5, height = 7.9*1.5)

# Visualize the ssp585
options(repr.plot.width = 13.43*1.5, repr.plot.height = 7.9*1.5)
(p.reg.fig.ssp585 <- plot_bmap(map = dataset.dts.aliyun$map) %>% 
    add_spatraster(spat.raster = reg.visual.dat.ssp585, facet.col.nums = 3) %>% 
    add_scale_bar(size = 1.5) %>% add_north_arrow() %>%add_crs())
saved <- savePDF(object = p.reg.fig.ssp585, path = outpath, filename = "p.reg.fig.ssp585.pdf", width = 13.43*1.5, height = 7.9*1.5)

# Predict the probability of p__Actinobacteria predominated soil
bio <- list(10, 16, c(1:5)) # "Grasslands", "Barren", "Forests"
cla.pred.rst <- lapply(climate.data, function(climate) cla %>% predict_ml_geomap(spat.raster = climate))
cla.pred.rst.masked <- lapply(cla.pred.rst, FUN = function(pre){
    inner.res <- lapply(bio, FUN = function(b){
        mask_spatraster_by_cla(tar.spat = pre$predominated, ref.spat = dataset.dts.aliyun$spa$rast$cla$LC_Type1, use.class = b)
    })
    names(inner.res) <- c("Grasslands", "Barren", "Forests")
    inner.res
})  

# Prepare visualizition data: SSP126
cla.visual.dat.ssp126 <- c(
    cla.pred.rst.masked$Historical$Grasslands        , cla.pred.rst.masked$Historical$Barren        , cla.pred.rst.masked$Historical$Forests,
    cla.pred.rst.masked$`SSP126|2021-2040`$Grasslands, cla.pred.rst.masked$`SSP126|2021-2040`$Barren, cla.pred.rst.masked$`SSP126|2021-2040`$Forests,
    cla.pred.rst.masked$`SSP126|2081-2100`$Grasslands, cla.pred.rst.masked$`SSP126|2081-2100`$Barren, cla.pred.rst.masked$`SSP126|2081-2100`$Forests
)
names(cla.visual.dat.ssp126) <- c("Historical|Grasslands", "Historical|Barren", "Historical|Forests", 
                                  "SSP126|2021-2040|Grasslands", "SSP126|2021-2040|Barren", "SSP126|2021-2040|Forests",
                                  "SSP126|2081-2100|Grasslands", "SSP126|2081-2100|Barren", "SSP126|2081-2100|Forests")

# Prepare visualizition data: SSP585
cla.visual.dat.ssp585 <- c(
    cla.pred.rst.masked$Historical$Grasslands        , cla.pred.rst.masked$Historical$Barren        , cla.pred.rst.masked$Historical$Forests,
    cla.pred.rst.masked$`SSP585|2021-2040`$Grasslands, cla.pred.rst.masked$`SSP585|2021-2040`$Barren, cla.pred.rst.masked$`SSP585|2021-2040`$Forests,
    cla.pred.rst.masked$`SSP585|2081-2100`$Grasslands, cla.pred.rst.masked$`SSP585|2081-2100`$Barren, cla.pred.rst.masked$`SSP585|2081-2100`$Forests
)
names(cla.visual.dat.ssp585) <- c("Historical|Grasslands", "Historical|Barren", "Historical|Forests", 
                                  "SSP585|2021-2040|Grasslands", "SSP585|2021-2040|Barren", "SSP585|2021-2040|Forests",
                                  "SSP585|2081-2100|Grasslands", "SSP585|2081-2100|Barren", "SSP585|2081-2100|Forests")

# Visualize the ssp126
options(repr.plot.width = 13.43*1.5, repr.plot.height = 7.9*1.5)
(p.cla.fig.ssp126 <- plot_bmap(map = dataset.dts.aliyun$map) %>% 
    add_spatraster(spat.raster = cla.visual.dat.ssp126, facet.col.nums = 3) %>% 
    add_scale_bar(size = 1.5) %>% add_north_arrow() %>%add_crs())
saved <- savePDF(object = p.cla.fig.ssp126, path = outpath, filename = "p.cla.fig.ssp126.pdf", width = 13.43*1.5, height = 7.9*1.5)

# Visualize the ssp585
options(repr.plot.width = 13.43*1.5, repr.plot.height = 7.9*1.5)
(p.cla.fig.ssp585 <- plot_bmap(map = dataset.dts.aliyun$map) %>% 
    add_spatraster(spat.raster = cla.visual.dat.ssp585, facet.col.nums = 3) %>% 
    add_scale_bar(size = 1.5) %>% add_north_arrow() %>%add_crs())
saved <- savePDF(object = p.cla.fig.ssp585, path = outpath, filename = "p.cla.fig.ssp585.pdf", width = 13.43*1.5, height = 7.9*1.5)
