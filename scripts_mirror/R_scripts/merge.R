suppressMessages(library(Seurat))
suppressMessages(library(ggplot2))

options(future.globals.maxSize = 8000 * 1024^2)
args <- commandArgs(trailingOnly = T)
indir <- args[1]
name <- args[2]
outdir <- args[3]
samples <- list.files(indir,full.names=F,pattern = "GSM")

objects <- paste0(list.files(indir,full.names=T,pattern = "GSM"),"/seurat_objects/",samples,"_seurat.rds") #mark for testing

object.list <- sapply(objects, readRDS)

objects.combined <- merge(x = object.list[[1]],y = object.list[-1], merge.data = TRUE)

objects.combined <- FindVariableFeatures(objects.combined, nfeatures = 3000)
objects.combined <-ScaleData(object = objects.combined, features = VariableFeatures(object = objects.combined), vars.to.regress = c("nCount_RNA", "percent.mt"))

npcs <- min(ncol(objects.combined) - 1, 50)
objects.combined <- RunPCA(object = objects.combined,
               features = VariableFeatures(object = objects.combined), 
               npcs=npcs)

objects.combined <- IntegrateLayers(object = objects.combined, method = HarmonyIntegration,
                              orig.reduction = "pca", new.reduction = 'pca', verbose = FALSE)

#elbowPlot <- ElbowPlot(objects.combined, ndims = 50)
#ggsave(paste0(outdir,"/","elbow_plot.pdf"), plot=elbowPlot, width=6, height=4)
#gc()
objects.combined <- RunTSNE(objects.combined,
                            reduction = "pca",
                            dims = 1:30, 
                            tsne.method = "FIt-SNE",
                            nthreads = 4, 
                            max_iter = 2000)
gc()
objects.combined <- RunUMAP(objects.combined, 
                            reduction = "pca", 
                            dims = 1:30)
gc()
## CLUSTERING

resolutions <- c(0.2, 0.4, 0.6, 0.8, 1.0) #see merge_samples.smk
defaultResolution <- 0.6
gc()
objects.combined <- FindNeighbors(object = objects.combined, reduction="pca", dims = 1:30)
objects.combined <- FindClusters(object = objects.combined, resolution = resolutions)

gc()
## Default resolution to be 0.6

allIdents <- paste0('RNA_snn_res.', resolutions)
defaultIdent <- paste0('RNA_snn_res.', defaultResolution)


Idents(objects.combined) <- defaultIdent

tsnePlot <- DimPlot(objects.combined, split.by = 'orig.ident', reduction = "tsne") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/",name,"/plots/",name,"_tsne_plot.pdf"), plot=tsnePlot, width=8, height=6)

umapPlot <- DimPlot(objects.combined, split.by = 'orig.ident', reduction = "umap") + theme(aspect.ratio = 1)
ggsave(paste0(outdir,"/",name,"/plots/",name,"_umap_plot.pdf"), plot=umapPlot, width=8, height=6)

## SAVING: DATASET
objects.combined <- JoinLayers(objects.combined)
saveRDS(objects.combined, file = paste0(outdir,"/",name,"/seurat_objects/","seurat_",name,".rds"))
