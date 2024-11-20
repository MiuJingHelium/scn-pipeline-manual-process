#!/bin/bash

WD=$1
# INDIR=$2  provide path to outs/align/
# but you know what :) I will hard code the paths
# no more user defined paths
# the output paths in the R scripts are currently hardcoded anyways
# you will need to use commandArgs in R script to allow for user defined
# output path. I know I have already used commandArgs, but whatever, 
# people just want to finish the pipeline 
# and know where to find everything:) 
# Just make everyone's life easier.
cd $WD
chmod +x scripts/R_single_job.sh
chmod +x scripts/R_merge_job.sh

# set up dependent job for single and merge
JOBID=$(./scripts/R_single_job.sh $WD | awk '{print $2}' | tr -d '<>')
./scripts/R_merge_job.sh $WD $JOBID


