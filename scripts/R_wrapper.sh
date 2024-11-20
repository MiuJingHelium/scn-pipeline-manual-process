#!/bin/bash

WD=$1
DATASET=$2 # remember to update docu
MODE=$3 # star of cellranger
SPECIES=$4
# INDIR=$2  provide path to outs/align/
# but you know what :) I will hard code the paths
# no more user defined paths
# the output paths in the R scripts are currently hardcoded anyways
# you will need to use commandArgs in R script to allow for user defined
# output path. I know I have already used commandArgs, but whatever, 
# people just want to finish the pipeline 
# and know where to find everything:) 
# Just make everyone's life easier.

DESC="info/${DATASET}_description.txt"
LINK="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc="


cd $WD
chmod +x scripts/R_steps/R_single_job.sh
chmod +x scripts/R_steps/R_merge_job.sh
chmod +x scripts/R_steps/scn_convert_wrapper.sh

# set up dependent job for single and merge
JOBID=$(./scripts/R_steps/R_single_job.sh $WD $DATASET $MODE | awk '{print $2}' | tr -d '<>')
JOBID2=$(./scripts/R_steps/R_merge_job.sh $WD $DATASET $JOBID | awk '{print $2}' | tr -d '<>')
### The followings are alternatives ###
#./scripts/R_steps/R_merge_job.sh $WD $DATASET $JOBID
# JOBID2=$(bjobs | grep 'R_merge' | awk '{print $1}')
#######################################
./scripts/R_steps/scn_convert_wrapper.sh $WD $DATASET $DESC $LINK $SPECIES $JOBID2


