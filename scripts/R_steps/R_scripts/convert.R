suppressMessages(library(Seurat))
suppressMessages(library(SCNPrep))
suppressMessages(library(data.table))


# study meta and sample meta can be missing
args <- commandArgs(trailingOnly=T)
level <- args[1] #
pattern <- args[2]
dataset_name <- args[3]
sample_name <- args[4]
description_file.path <- args[5] 
link <- args[6]

title <- ""
description <- read.delim(description_file.path,header=F)

token <- args[7]
species <- args[8]


if (level == "dataset") {
  title <- dataset_name
  description <- sprintf("%s | %s", dataset_name,description)
  seurat <- readRDS(paste0("outs/R_outs/",dataset_name,"/seurat_objects/seurat_",dataset_name,".rds"))
  markers_files <- list.files(path=paste0("outs/R_outs/",dataset_name,"/markers/"),pattern=paste0(pattern,"_markers"),full.names=T)
} else if (level == "sample") {
  # sample <- samples[samples$alias == token, ]
  title <- sample_name
  description <- sprintf("%s | %s | %s", dataset_name,sample_name,description)
  # link <- sub(sample$link, pattern = "&api_key.*", replacement = "")
  seurat <- readRDS(list.files(path=paste0("outs/R_outs/",token,"/seurat_objects/"),pattern=pattern,full.names = T))
  markers_files <- list.files(path=paste0("outs/R_outs/",token,"/markers/"),pattern=paste0(pattern,"_markers"),full.names=T)
}

markers <- list()
for (markers_file in markers_files) {
  file_name <- basename(markers_file)

  table <- tryCatch({
    table_tmp <- as.data.frame(fread(markers_file))
    table_tmp$cluster <- as.factor(table_tmp$cluster)
    table_tmp
  },
  error=function(cond) {
    message(paste("Error while fread:", markers_file))
    message("Here's the original error message:")
    message(cond)
    return(NULL)
  })
  markers[[file_name]] <- table
}

out_dir <- paste0("outs/R_outs/",token,"/scn/")
print(paste(species,title,description,link,token,sep = ";"))
migrateSeuratObject(seurat,
                    species=species,
                    name=title,
                    description=description,
                    link=link,
                    outdir=out_dir,
                    token=token,
                    generateMasks=F,
                    markers=markers,
                    public = T,
                    curated = F,
                    generateGMTS = T)

validateSCDataset(out_dir)
