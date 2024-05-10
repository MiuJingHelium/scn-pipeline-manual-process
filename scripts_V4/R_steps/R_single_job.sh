#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
DATASET=$2
MODE=$3
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD

chmod +x scripts/R_steps/R_single_process_wrapper.sh

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J R_analysis -n 8 -M 32GB -o R_analysis.out \
	-e R_analysis.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	"scripts/R_steps/R_single_process_wrapper.sh `pwd` $DATASET $MODE"
