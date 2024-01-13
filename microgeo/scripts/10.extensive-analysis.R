suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# Use the map downloaded from DataV.GeoAtlas
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages() # head(map@data)
dataset.dts.aliyun <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                                     phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude")
dataset.dts.aliyun$map@data$NAME <- c("Tibet", "Qinghai", "Sichuan") 
dataset.dts.aliyun %<>% rarefy_count_table()
dataset.dts.aliyun %<>% tidy_dataset()
dataset.dts.aliyun %<>% calc_alpha_div(measures = c("observed", "shannon"))
dataset.dts.aliyun %>% show_dataset()

# Extract a new metadata from a common map
metadata <- dataset.dts.aliyun$map %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata)

# Calculate the spearman correlation between shannon index and soil pH for each naive polygon[e.g., Sichuan]
cor.res.c.df <- lapply(unique(metadata$NAME), function(name){
    samples <- metadata[which(metadata$NAME == name),] %>% row.names() 
    if (samples %>% length > 5){ # At least five sample for each polygon
        cor.res <- psych::corr.test(dataset.dts.aliyun$div$alpha[samples,]$shannon, 
                                    dataset.dts.aliyun$env[samples,]$pH, method = 'spearman')
        dd <- data.frame(polygon = name, r = cor.res$r, p = cor.res$p)
    }else{
        dd <- data.frame(polygon = name, r = NA, p = NA)
    }
    dd
}) %>% do.call('rbind', .)
head(cor.res.c.df)

# Merge the correlation coefficients with `SpatialPolygonsDataFrame` 
new.map <- dataset.dts.aliyun$map
mapdata.add.data <- lapply(new.map@data$NAME, function(name) {
    d <- cor.res.c.df[which(cor.res.c.df$polygon == name),]
    ddd <- data.frame(r = NA, p = NA, label = NA)
    if (d %>% nrow > 0) {
        ddd <- d[,2:3]
        ddd$label <- paste0("r = ", round(ddd$r, 2), ", p = ", round(ddd$p, 2))
    }
    ddd
}) %>% do.call('rbind', .)
new.map@data <- cbind(new.map@data, mapdata.add.data)
head(new.map@data)

# Visualize the results 
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
new.map %>% plot_bmap(var = 'NAME', ord = c('Sichuan', 'Qinghai', 'Tibet'), 
                      fill = RColorBrewer::brewer.pal(8, "Set2")[1:3], legend.position = c(0.06, 0.255)) %>%
    add_label(dat = new.map@data, lab.var = 'NAME', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5) %>% 
    add_label(dat = new.map@data, lab.var = 'label', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 5, vjust = 3) %>%
    add_scale_bar() %>% add_north_arrow() %>% add_crs() %>% suppressWarnings()

# Grid the map using the resolution of 1.5
gridded.map <- grid_map(map = dataset.dts.aliyun$map, res = 1.5) %>% suppressMessages
head(gridded.map@data)

# Extract a new metadata from a gridded map
metadata2 <- gridded.map %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata2)

# Calculate the spearman correlation between shannon index and soil pH for each grid
cor.res.g.mx <- lapply(unique(metadata2$NAME), function(name){
    samples <- metadata2[which(metadata2$NAME == name),] %>% row.names() 
    if (samples %>% length > 5){ # At least five sample for each grid
        cor.res <- psych::corr.test(dataset.dts.aliyun$div$alpha[samples,]$shannon, 
                                    dataset.dts.aliyun$env[samples,]$pH, method = 'spearman')
        dd <- data.frame(polygon = name, r = cor.res$r, p = cor.res$p)
    }else{
        dd <- data.frame(polygon = name, r = NA, p = NA)
    }
    dd
}) %>% do.call('rbind', .)
head(cor.res.g.mx)

# Merge the correlation coefficients with `SpatialPolygonsDataFrame` 
new.map <- gridded.map
mapdata.add.data <- lapply(new.map@data$NAME, function(name) {
    d <- cor.res.g.mx[which(cor.res.g.mx$polygon == name),]
    ddd <- data.frame(r = NA, p = NA, label = NA)
    if (d %>% nrow > 0) {
        ddd <- d[,2:3]
        ddd$label <- paste0("r = ", round(ddd$r, 2), ", p = ", round(ddd$p, 2))
    }
    ddd
}) %>% do.call('rbind', .)
new.map@data <- cbind(new.map@data, mapdata.add.data)
head(new.map@data)

# Visualize the results 
options(repr.plot.width = 16.4 * 2, repr.plot.height = 8.02)
e22 <- new.map %>% plot_bmap(var = 'r', fill = 'auto') %>% 
    add_label(dat = new.map@data, lab.var = 'p', lon.var = 'X.CENTER', lat.var = 'Y.CENTER', size = 6) %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
e33 <- new.map %>% plot_bmap(var = 'r', fill = 'auto') %>%
    add_point(dat = new.map@data, lab.var = 'p', lon.var = "X.CENTER", lat.var = "Y.CENTER") %>% 
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
cowplot::plot_grid(e22, e33, align = 'hv', ncol = 2, labels = c("a", "b"), label_size = 28) %>% suppressWarnings()

# Grid the map using the resolution of 1.5
gridded.map <- grid_map(map = dataset.dts.aliyun$map, res = 1.5) %>% suppressMessages
head(gridded.map@data) 

# Extract a new metadata from a gridded map
metadata3 <- gridded.map %>% extract_metadata_from_map(met = dataset.dts.aliyun$met)
head(metadata3)  

# Merge alpha diversity indices with a gridded map
gridded.map.mean4df <- merge_dfs_to_map(map = gridded.map, dat = dataset.dts.aliyun$div$alpha, met = dataset.dts.aliyun$met, med = 'mean')
head(gridded.map.mean4df@data[,1:12])

# The complete clustering for average shannon index in each grid
dat.new <- data.frame(row.names = gridded.map.mean4df$NAME, val = as.numeric(gridded.map.mean4df$shannon_mean)) %>% na.omit()
cls.num <- fpc::pamk(dat.new)$nc # automatically determining the cluster number
hcs <- hclust(d = dist(dat.new), method = 'complete')
ctr <- cutree(hcs, k = cls.num) %>% as.data.frame()
ctr <- data.frame(grids = rownames(ctr), cluster = ctr[,1])
head(ctr)

# Visualize the clustering results 
options(repr.plot.width = 12, repr.plot.height = 12)
hc.d <- ggdendro::dendro_data(as.dendrogram(hcs))
hc.d$labels$cluster <- lapply(hc.d$labels$label, function(lab) ctr[which(ctr$grids == lab),]$cluster %>% paste("Cluster", ., sep = "-")) %>% unlist()
ggplot(data = ggdendro::segment(hc.d)) + geom_segment(aes(x=x, y=y, xend=xend, yend=yend)) + theme_bw() + scale_y_reverse() +
    geom_text(data=hc.d$labels, aes(x = x, y = y, label = label, color = cluster), hjust = -0.3, size = 6) +
    theme(axis.ticks = element_blank(), axis.text = element_blank(), axis.title = element_blank(),
          legend.position = c(0.1, 0.8), legend.title = element_text(size = 22),
          legend.text = element_text(size = 20)) + coord_flip()

# Add clustering results to metadata 
# The new metadata can be used for extensive statistical analysis
metadata3$cluster <- lapply(metadata3$NAME, function(x){
    dd <- ctr[which(ctr$grids == x),]
    res <- ifelse(nrow(dd) == 0, NA, dd$cluster)
}) %>% unlist()
metadata3$cluster <- paste0("CC-", metadata3$cluster)
head(metadata3)

# Merge clustering results with the gridded map
new.map <- gridded.map
mapdata.add.data <- lapply(new.map@data$NAME, function(name) {
    d <- ctr[which(ctr$grids == name),]
    ddd <- data.frame(grids = NA, cluster = NA)
    if (nrow(d) > 0) ddd <- d[,1:2]
    ddd
}) %>% do.call('rbind', .)
mapdata.add.data$cluster <- paste0("CC-", mapdata.add.data$cluster)
new.map@data <- cbind(new.map@data, mapdata.add.data)
head(new.map@data)

# Visualize clustering results
options(repr.plot.width = 15.4, repr.plot.height = 8.02)
new.map %>% plot_bmap(var = 'cluster', fill = c(RColorBrewer::brewer.pal(9, "Set1")[1:2], "white")) %>% 
    add_label(dat = new.map@data, lab.var = "NAME", lon.var = "X.CENTER", lat.var = "Y.CENTER", remove.na = TRUE) %>%
    add_scale_bar() %>% add_north_arrow() %>% add_crs()

# K-mean clustering 
set.seed(123456)
dat.new <- aggregate(t(dataset.dts.aliyun$mat), by = list(metadata3$NAME), FUN = mean)
row.names(dat.new) <- dat.new[,1]; dat.new <- dat.new[,-1]
cls.num <- fpc::pamk(dat.new)$nc # automatically determining cluster number
kms <- kmeans(dat.new, centers = cls.num)
ctr <- data.frame(grids = names(kms$cluster), cluster = kms$cluster)

# Visualize the clustering results 
options(repr.plot.width = 12, repr.plot.height = 12)
factoextra::fviz_cluster(kms, data = dat.new, ggtheme = theme_bw(),
    main = "", repel = TRUE, show.clust.cent = TRUE, palette = RColorBrewer::brewer.pal(9, "Set1")[1:3], labelsize = 12, pointsize = 3,
    legend = 'top', font.x = c(14, "plain", "black"), font.y = c(14, "plain", "black"), legend.title = "Clusters",
    font.tickslab = c(12, "plain", "black"), font.legend = c(14, "plain", "black"))

# Add clustering results to metadata 
# The new metadata can be used for extensive statistical analysis
metadata3$cluster <- lapply(metadata3$NAME, function(x){
    dd <- ctr[which(ctr$grids == x),]
    res <- ifelse(nrow(dd) == 0, NA, dd$cluster)
}) %>% unlist()
metadata3$cluster <- paste0("KC-", metadata3$cluster)
head(metadata3)

# Merge clustering results with the gridded map
new.map <- gridded.map
mapdata.add.data <- lapply(new.map@data$NAME, function(name) {
    d <- ctr[which(ctr$grids == name),]
    ddd <- data.frame(grids = NA, cluster = NA)
    if (nrow(d) > 0) ddd <- d[,1:2]
    ddd
}) %>% do.call('rbind', .)
mapdata.add.data$cluster <- paste0("KC-", mapdata.add.data$cluster)
new.map@data <- cbind(new.map@data, mapdata.add.data)
head(new.map@data)

# Visualize clustering results
options(repr.plot.width = 16.4, repr.plot.height = 8.02)
new.map %>% plot_bmap(var = 'cluster', fill = c(RColorBrewer::brewer.pal(9, "Set1")[1:2], "white")) %>% 
    add_label(dat = new.map@data, lab.var = "NAME", lon.var = "X.CENTER", lat.var = "Y.CENTER", remove.na = TRUE) %>%
    add_scale_bar() %>% add_north_arrow() %>% add_crs()
