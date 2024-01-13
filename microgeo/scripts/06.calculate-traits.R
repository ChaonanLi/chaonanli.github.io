suppressMessages(require("magrittr")) 
require("ggplot2")  %>% suppressMessages()
require("microgeo") %>% suppressMessages()

prev_locale <- Sys.setlocale("LC_CTYPE", "C.UTF-8") 

# Using the map downloaded from DataV.GeoAtlas
data(qtp)
map <- read_aliyun_map(adcode = c(540000, 630000, 510000)) %>% suppressMessages() 
dataset.dts.aliyun <- create_dataset(mat = qtp$asv, ant = qtp$tax, met = qtp$met, map = map,
                                     phy = qtp$tre, env = qtp$env, lon = "longitude", lat = "latitude") 
dataset.dts.aliyun %<>% rarefy_count_table() 
dataset.dts.aliyun %<>% tidy_dataset()
dataset.dts.aliyun %>% show_dataset()

# Calculate relative abundance
dataset.dts.aliyun %<>% calc_rel_abund() %>% suppressMessages()
head(dataset.dts.aliyun$abd$raw$Phylum[,1:5])

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Identify ecological markers based on soil pH in <env>[Correlation]
dataset.dts.aliyun %<>% calc_markers(use.var = 'pH', annotation.level = 'Phylum', r.thres = 0.1, use.dat = 'env') 

# Show markers 
head(dataset.dts.aliyun$abd$mar$correlation)

# Identify ecological markers based on soil pH and TOC in <env> [Mantel test]
dataset.dts.aliyun %<>% calc_markers(use.var = c('pH', 'TOC'), annotation.level = 'Phylum', r.thres = 0.1, use.dat = 'env') 

# Show markers 
head(dataset.dts.aliyun$abd$mar$correlation)

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Calculate alpha diversity indices
dataset.dts.aliyun %<>% calc_alpha_div(measures = c("observed", "shannon")) %>% suppressMessages()

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Calculate alpha diversity indices
dataset.dts.aliyun %<>% calc_beta_div(measures = c("bray", "jaccard")) %>% suppressMessages()

# Show dataset 
dataset.dts.aliyun %>% show_dataset()

# Check results [Bray-Curtis distance]
dataset.dts.aliyun$div$bet$bray[1:4, 1:4]

# Calculate `alpha.phylo` null model
# runs = 9 just for an example. 999 runs may be better 
dataset.dts.aliyun %<>% calc_phylo_asmb(type = 'alpha.phylo', runs = 9, out.dir = 'test/calc_comm_asmb') %>% suppressMessages()

# Check results 
head(dataset.dts.aliyun$asb$alpha.phylo)

# Calculate `beta.phylo` null model
# runs = 9 just for an example. 999 runs may be better 
dataset.dts.aliyun %<>% calc_phylo_asmb(type = 'beta.phylo', runs = 9, out.dir = 'test/calc_comm_asmb') %>% suppressMessages()

# Check distance matrix 
names(dataset.dts.aliyun$asb$beta.phylo$dis) # distance matrices

# Check the results 
head(dataset.dts.aliyun$asb$beta.phylo$raw$result) # the raw result of `iCAMP::qpen()`

# Show dataset 
dataset.dts.aliyun %>% show_dataset()
