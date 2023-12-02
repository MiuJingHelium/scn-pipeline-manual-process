library(ggplot2)
library(flexmix)
library(glmGamPoi)
library(Seurat)
library(SeuratWrappers)
library(jsonlite)

theme_set(theme_bw(base_size = 8))
set.seed(1)
args <- commandArgs(trailingOnly = T)
input_obj <- args[1]
sample <- args[2] #sample name or SRR accession
outdir <- args[3]

counts <- readRDS(input_obj)
data <- CreateSeuratObject(counts, project=sample, min.cells = 3, min.features = 10)

data <- PercentageFeatureSet(data, pattern = "^Mt\\.|^MT\\.|^mt\\.|^Mt-|^MT-|^mt-", col.name = "percent.mt")
data[['percent.mt_log10']] <- log10(data[['percent.mt']] + 1)
data[['nCount_RNA_log10']] <- log10(data[['nCount_RNA']] + 1)
data[['nFeature_RNA_log10']] <- log10(data[['nFeature_RNA']] + 1)


## QC Plots
vlnFeaturePlots <- VlnPlot(data, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), pt.size=0.1)
ggsave(paste0(outdir,"/plots/",sample,"_vln_feature_plots.pdf"), plot=vlnFeaturePlots, width=6, height=4)

umiMtPlot <- FeatureScatter(data, feature1 = "nCount_RNA", feature2 = "percent.mt") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_mt_plot.pdf"), plot=umiMtPlot, width=6, height=4)

umiFeaturesLog10Plot <- FeatureScatter(data, feature1 = "nCount_RNA_log10", feature2 = "nFeature_RNA_log10") +
  theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_features_log10_plot.pdf"), plot=umiFeaturesLog10Plot, width=6, height=4)

umiFeaturesPlot <- FeatureScatter(data, feature1 = "nCount_RNA", feature2 = "nFeature_RNA") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_features_plot.pdf"), plot=umiFeaturesPlot, width=6, height=4)

## Number of cells before

cells.before <- dim(data)[2]

data <- RunMiQC(data, 
                percent.mt = "percent.mt", 
                nFeature_RNA = "nFeature_RNA", 
                posterior.cutoff = 0.75, 
                model.slot = "flexmix_model")

tryCatch({
  miqcPlotProb <- PlotMiQC(data, color.by = "miQC.probability") +
    scale_color_gradient(low = "grey", high = "purple")
  ggsave(paste0(outdir,"/plots/",sample,"_miqc_plot_prob.pdf"), plot=miqcPlotProb, width=6, height=4)
}, error = function(e) {
  message(e)
  pdf(paste0(outdir,"/plots/",sample,"_miqc_plot_prob.pdf"), width=6, height=4)
  dev.off()
})

miqcPlotKeep <- FeatureScatter(data, feature1 = "nFeature_RNA", feature2 = "percent.mt", group.by = "miQC.keep") +
  theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_miqc_plot_keep.pdf"), plot=miqcPlotKeep, width=6, height=4)

## FILTER MT CONTENT

data <- subset(data, miQC.keep == "keep")

## Number of cells after

seurat_stats <- list()

cells.after <- dim(data)[2]
print(paste0("cells.before:",cells.before))
print(paste0("cells.after:",cells.after))
print(paste0("cell.diff:", cells.before-cells.after))

seurat_stats$cells_before_mt_filtering <- cells.before
seurat_stats$cells_after_mt_filtering <- cells.after
seurat_stats$cells_filtered_mt <- cells.before-cells.after

## plots after filtering

## QC Plots

vlnFeaturePLotsAfterLog <- VlnPlot(data, features = c("nFeature_RNA_log10","nCount_RNA_log10","percent.mt"), pt.size=0.1)
ggsave(paste0(outdir,"/plots/",sample,"_vln_feature_plots_after_log.pdf"), plot=vlnFeaturePLotsAfterLog, width=6, height=4)

vlnFeaturePlotsAfter <- VlnPlot(data, features = c("nFeature_RNA","nCount_RNA","percent.mt"), pt.size=0.1)
ggsave(paste0(outdir,"/plots/",sample,"_vln_feature_plots_after.pdf"), plot=vlnFeaturePlotsAfter, width=6, height=4)

umiMtPlotAfter <- FeatureScatter(data, feature1 = "nCount_RNA", feature2 = "percent.mt") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_mt_plot_after.pdf"), plot=umiMtPlotAfter, width=6, height=4)

umiFeaturesLog10PlotAfter <- FeatureScatter(data, feature1 = "nCount_RNA_log10", feature2 = "nFeature_RNA_log10") +
  theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_features_log10_plot_after.pdf"), plot=umiFeaturesLog10PlotAfter, width=6, height=4)

umiFeaturesPlotAfter <- FeatureScatter(data, feature1 = "nCount_RNA", feature2 = "nFeature_RNA") +
  theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umi_features_plot_after.pdf"), plot=umiFeaturesPlotAfter, width=6, height=4)


## NORMALIZATION

data <- SCTransform(
  data,
  method = "glmGamPoi",
  ncells=min(100000, ncol(data)),
  vars.to.regress = c("percent.mt"),
  verbose = T,
  conserve.memory = T
)

## PCA
npcs <- min(ncol(data) - 1, 50)
data <- RunPCA(object = data,
               features = VariableFeatures(object = data), 
               npcs=npcs)

elbowPlot <- ElbowPlot(data, ndims = npcs)
ggsave(paste0(outdir,"/plots/",sample,"_elbow_plot.pdf"), plot=elbowPlot, width=6, height=4)

## TSNE
perplexity <- min(floor((ncol(data) - 1) / 3), 30)
data <- RunTSNE(data, 
                dims = 1:20,
                perplexity = perplexity,
                tsne.method = "FIt-SNE",
                nthreads = 4, 
                max_iter = 2000)


## UMAP
data <- RunUMAP(data, dims = 1:20, n.neighbors = perplexity)


## CLUSTERING

resolutions <- seq(0.2,1,0.2) #See seurat_analysis.smk
defaultResolution <- 0.6 # Same as above

data <- FindNeighbors(object = data, dims = 1:20)
data <- FindClusters(object = data, resolution = resolutions)


## Default resolution to be 0.6

allIdents <- paste0('SCT_snn_res.', resolutions)
defaultIdent <- paste0('SCT_snn_res.', defaultResolution)

seurat_stats$clustering <- list()
for (ident in allIdents) {
  seurat_stats$clustering[[ident]] <- length(levels(data@meta.data[[ident]]))
}

Idents(data) <- defaultIdent

tsnePlot <- DimPlot(data, reduction = "tsne") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_tsne_plot.pdf"), plot=tsnePlot, width=6, height=4)

umapPlot <- DimPlot(data, reduction = "umap") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/plots/",sample,"_umap_plot.pdf"), plot=umapPlot, width=6, height=4)


## SAVING: DATASET

write(toJSON(seurat_stats, auto_unbox = T, pretty = T),
      paste0(outdir,"/stats/",sample,"_seurat_stats.json"))

saveRDS(data, file = paste0(outdir,"/seurat_objects/",sample,"_seurat.rds"))
