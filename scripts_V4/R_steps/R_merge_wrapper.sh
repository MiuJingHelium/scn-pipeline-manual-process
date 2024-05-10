#!/bin/bash

WD=$1
DATASET=$2
cd $WD

mkdir -p outs/R_outs/$DATASET/seurat_objects/
mkdir -p outs/R_outs/${DATASET}/plots/
mkdir -p outs/R_outs/${DATASET}/stats/
mkdir -p outs/R_outs/${DATASET}/markers/
mkdir -p outs/R_outs/${DATASET}/revPCA/

Rscript scripts/R_steps/R_scripts/merge.R outs/R_outs/ $DATASET outs/R_outs/
Rscript scripts/R_steps/R_scripts/markers.R outs/R_outs/$DATASET/seurat_objects/seurat_${DATASET}.rds ${DATASET} outs/R_outs/${DATASET}/
Rscript scripts/R_steps/R_scripts/revPCA_dataset.R outs/R_outs/${DATASET}/seurat_objects/seurat_${DATASET}.rds $DATASET outs/R_outs/${DATASET}/revPCA/ 
