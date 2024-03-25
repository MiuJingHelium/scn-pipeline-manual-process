#!/bin/bash

WD=$1
cd $WD
mkdir -p outs/R_outs/merged/
Rscript scripts/R_scripts/merge.R outs/R_outs/seurat_objects/ outs/R_outs/merged/
Rscript scripts/R_scripts/markers.R outs/R_outs/merged/seurat_merged.rds merged outs/R_outs/ 
