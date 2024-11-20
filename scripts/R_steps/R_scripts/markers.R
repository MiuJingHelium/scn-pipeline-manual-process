suppressMessages(library(ggplot2))
suppressMessages(library(Seurat))

args <- commandArgs(trailingOnly = T)
input_obj <- args[1]# provide path to the object
data <- readRDS(input_obj)
GSM <- args[2]
outdir <- paste0(args[3],"/markers/")

DefaultAssay(data) <- "RNA"
#data <- NormalizeData(data)

averagePCT <- function(seurat,
                       ident, # columns from @meta.data
                       assay="RNA",
                       layer="counts",
                       threshold=0) {
  seurat <- SetIdent(seurat, value=ident)
  allLevels <- levels(Idents(seurat))
  data <- GetAssayData(seurat, assay=assay, layer=layer)

  results <- matrix(nrow=nrow(data), ncol=length(allLevels),
                    dimnames = list(rownames(data), allLevels))

  for (i in 1:length(allLevels)) {
    ident <- allLevels[i]
    cell.ids <- which(Idents(seurat) == ident)
    results[, i] <- round(rowSums(data[, cell.ids, drop=F] > threshold) / length(cell.ids), digits=3)
  }
  return(results)
}

averageExpression <- function(seurat,
                              ident,
                              assay="RNA",
                              layer="data") {
  cluster.averages <- AverageExpression(object = seurat, group.by=ident, assays = assay, layer = layer)
  return(cluster.averages[[1]])
}

allMarkers <- function(seurat,
                       ident,
                       assay="RNA",
                       layer="data") {

  Idents(seurat) <- ident
  whole.markers <- FindAllMarkers(object = seurat,
                                  assay=assay,
                                  layer=layer,
                                  only.pos = TRUE,
                                  min.pct = 0.10,
                                  test.use = 'wilcox',
                                  max.cells.per.ident = 3e3,
                                  random.seed = 42)
  return(whole.markers)
}

resolutions <- c(0.2, 0.4, 0.6, 0.8, 1.0)

for (res in resolutions) {

  identName <- paste0('RNA_snn_res.', res)

  clusterAverages <- averageExpression(data, identName)
  write.table(clusterAverages, file=paste0(outdir,"/",GSM,"_clusters_",res,"_average.tsv"))

  clusterPCTs <- averagePCT(data, identName)
  write.table(clusterPCTs, file=paste0(outdir,"/",GSM,"_clusters_",res,"_pct.tsv"))

  deResults <- allMarkers(data, identName)
  write.table(deResults,
              paste0(outdir,"/",GSM,"_markers_",res,".tsv"),
              sep="\t",
              quote=F,
              row.names=F)
  
}
