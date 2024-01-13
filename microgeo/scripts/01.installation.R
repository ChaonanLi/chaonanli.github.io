# Install the `remotes` R package as the microgeo R package is now available on both GitHub and Gitee
if (!suppressMessages(require('remotes', character.only = TRUE))) 
    install.packages('remotes', dependencies = TRUE, repos = "http://cran.rstudio.com/")

# Install the `mcirogeo` R package from GitHub
if (!suppressMessages(require('microgeo', character.only = TRUE)))
     remotes::install_github('ChaonanLi/microgeo') 

# Install the `mcirogeo` R package from Gitee
if (!suppressMessages(require('microgeo', character.only = TRUE)))
    remotes::install_git("https://gitee.com/bioape/microgeo")

# Install additional R packages required by `microgeo`
source(system.file("scripts", "install-extra-pkgs.R", package = "microgeo")) 
