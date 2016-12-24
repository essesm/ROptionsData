#!/bin/bash

REPO=${1:-'http://cran.us.r-project.org'}
Rscript install_packages.R $REPO
