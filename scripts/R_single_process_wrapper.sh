#!/bin/bash

WD=$1 #include GSE ID
INDIR="outs/align/"
cd $WD

mkdir -p outs/R_outs/filtered_counts/
mkdir -p outs/R_outs/seurat_objects/
mkdir -p outs/R_outs/plots/
mkdir -p outs/R_outs/stats/
mkdir -p outs/R_outs/markers/

for GSM in $( ls $INDIR );do
	 echo "Running filter_counts.R for ${GSM}."
	 Rscript scripts/R_scripts/filter_counts.R outs/align/$GSM/Solo.out/Gene/filtered/ $GSM outs/R_outs/filtered_counts/
	echo "Running seurat_analysis.R for ${GSM}."
	Rscript scripts/R_scripts/seurat_analysis.R outs/R_outs/filtered_counts/${GSM}_filtered_counts.rds $GSM outs/R_outs/
	echo "Running markers.R for ${GSM}."
	Rscript scripts/R_scripts/markers.R outs/R_outs/seurat_objects/${GSM}_seurat.rds $GSM outs/R_outs/
done	
#mkdir -p outs/R_outs/merged/
#Rscript R_scripts/merge.R outs/R_outs/seurat_objects/ outs/R_outs/merged/

