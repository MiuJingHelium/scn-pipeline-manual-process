suppressMessages(library(Matrix))
suppressMessages(library(Seurat))
suppressMessages(library(glmGamPoi))
suppressMessages(library(ggplot2))
suppressMessages(library(ggrepel))
suppressMessages(library(dplyr))

args <- commandArgs(trailingOnly = T)
input_data <- args[1]# the path to rds
sample_name <- args[2]
outdir <- args[3]

data <- readRDS(input_data)
DefaultAssay(data) <- "RNA"

data <- FindVariableFeatures(data, nfeatures = 3000)
top20_variable_genes <- head(VariableFeatures(data), 20)
vfPlot <- VariableFeaturePlot(data) %>%
  LabelPoints(points = top20_variable_genes, repel = TRUE) +
  scale_y_log10()

ggsave(paste0(outdir,sample_name,"_variable_feature_plot.pdf"), plot=vfPlot, width=6, height=4)

npcs <- min(ncol(data) - 1, 50)
data <- RunPCA(data,
               assay = "RNA",
               verbose = FALSE,
               npcs = npcs,
               rev.pca = TRUE,
               reduction.name = "pca.rev",
               reduction.key="PCR_")

E <- data@reductions$pca.rev@feature.loadings
saveRDS(E, file = paste0(outdir,sample_name,"_rev_pca.rds"))
