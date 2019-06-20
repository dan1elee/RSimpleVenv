#!/usr/bin/env Rscript
#
# Install an R package from the command line. Supports CRAN, GitHub, and local 
# packages.
#
# It is expected that this is only run through R_setup.sh.
#
# Author: G.J.J. van den Burg
# Date: 2019-06-20
# License: MIT

REPOS <- c("https://cran.r-project.org")

# Parse args
args <- commandArgs(trailingOnly=T)
if (!length(args) == 1) {
    print("Please provide a package name")
    quit()
}
pkg <- args[1]

# As a sanity check, ensure that nothing overwrote the R_LIBS variable
if (Sys.getenv("R_LIBS") != .libPaths()[1]) {
    print("Mismatch between R_LIBS and .libPaths()[1]")
    quit(status=1, save="no")
}

# Install the package
if (startsWith(pkg, "github:")) {
    pkg <- substring(pkg, nchar("github:")+1, nchar(pkg))
    # this check only works if the package name matches the repo name
    pkgName <- basename(pkg)
    if (pkgName %in% installed.packages()) {
        cat("Package", pkgName, "exists.\n")
        quit()
    }
    Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")
    # install_github returns the package name (yay!)
    pkg <- devtools::install_github(pkg)
} else if (startsWith(pkg, "local:")) {
    pkgPath <- substring(pkg, nchar("local:")+1, nchar(pkg))
    pkgName <- basename(pkgPath)
    if (pkgName %in% installed.packages()) {
        cat("Package", pkgName, "exists.\n")
        quit()
    }
    devtools::build(pkgPath)
    devtools::install(pkgPath)
    pkg <- pkgName
} else {
    if (pkg %in% installed.packages()) {
        cat("Package", pkg, "exists.\n")
        quit()
    }
    install.packages(pkg, Sys.getenv("R_LIBS"), repos=REPOS, 
                     dependencies=c("Depends", "Imports", "LinkingTo"))
}

# Test if it works
if (!library(pkg, character.only=T, logical.return=T))
    quit(status=1, save='no')
