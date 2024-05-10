suppressMessages(library(DropletUtils))
suppressMessages(library(Matrix))
suppressMessages(library(data.table))
suppressMessages(library(ggplot2))
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(jsonlite))
suppressMessages(library(Seurat))

# Gene Mapping
args <- commandArgs(trailingOnly = T)
data_dir <- args[1] #Provide the path to the files as a command-line argument
name <- args[2] #Provide the GSM accession as the second argument. 
outdir <- args[3] #provide outdir as the third argument
data <- Read10X(data_dir)
data <- data[rowSums(data) > 0, ]
saveRDS(data, file=paste0(outdir,"/",name,"_filtered_counts.rds"))
