#!/bin/bash

WD=$1 #include GSE ID
DATASET=$2
INDIR="outs/align/"
cd $WD


for GSM in $( ls $INDIR );do
	mkdir -p outs/R_outs/${DATASET}_${GSM}/filtered_counts/
	mkdir -p outs/R_outs/${DATASET}_${GSM}/seurat_objects/
	mkdir -p outs/R_outs/${DATASET}_${GSM}/plots/
	mkdir -p outs/R_outs/${DATASET}_${GSM}/stats/
	mkdir -p outs/R_outs/${DATASET}_${GSM}/markers/
	echo "Running filter_counts.R for ${GSM}."
	 Rscript scripts/R_scripts/filter_counts.R outs/align/$GSM/Solo.out/Gene/filtered/ ${DATASET}_${GSM} outs/R_outs/${DATASET}_${GSM}/filtered_counts/
	echo "Running seurat_analysis.R for ${GSM}."
	Rscript scripts/R_scripts/seurat_analysis.R outs/R_outs/${DATASET}_${GSM}/filtered_counts/${DATASET}_${GSM}_filtered_counts.rds ${DATASET}_${GSM} outs/R_outs/${DATASET}_${GSM}/
	echo "Running markers.R for ${GSM}."
	Rscript scripts/R_scripts/markers.R outs/R_outs/${DATASET}_${GSM}/seurat_objects/${DATASET}_${GSM}_seurat.rds $GSM outs/R_outs/${DATASET}_${GSM}/
	
	mkdir -p outs/R_outs/${DATASET}_${GSM}/revPCA/
	Rscript scripts/R_scripts/revPCA_sample.R outs/R_outs/${DATASET}_${GSM}/seurat_objects/${DATASET}_${GSM}_seurat.rds ${DATASET}_${GSM} outs/R_outs/${DATASET}_${GSM}/revPCA/
done	
#mkdir -p outs/R_outs/merged/
#Rscript R_scripts/merge.R outs/R_outs/seurat_objects/ outs/R_outs/merged/

