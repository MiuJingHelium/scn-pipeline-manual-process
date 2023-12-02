#!/bin/bash

WD=$1 #include GSE ID

cd $WD

for SRR in $(ls outs/align/);do
	mkdir -p outs/R_outs/filtered_counts/
	Rscript scripts/filter_counts.R outs/align/$SRR/Solo.out/Gene/filtered/ $SRR outs/R_outs/filtered_counts/
	mkdir -p outs/R_outs/seurat_objects/
	mkdir -p outs/R_outs/plots/
	mkdir -p outs/R_outs/stats/
	Rscript scripts/seurat_analysis.R outs/R_outs/filtered_counts/${SRR}_filtered_counts.rds $SRR outs/R_outs/
	mkdir -p outs/R_outs/markers/
	Rscript scripts/markers.R outs/R_outs/seurat_objects/${SRR}_seurat.rds $SRR outs/R_outs/
done	
	

