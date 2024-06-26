#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
DATASET=$2
#JOBID=$3
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD

chmod +x scripts/R_steps/R_merge_wrapper.sh

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J R_merge -n 8 -M 32GB -o R_merge.out \
	-e R_merge.err -R 'select[mem>64MB] rusage[mem=32GB] span[hosts=1]' \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	"scripts/R_steps/R_merge_wrapper.sh `pwd` $DATASET"
