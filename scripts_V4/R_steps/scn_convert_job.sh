#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
LEVEL=$2
PATTERN=$3
DATASET=$4
SAMPLE=$5
DESC=$6
LINK=$7
TOKEN=$8
SPEC=$9
JOBID2=${10} # This is important :)))

# echo ${LEVEL}_${JOBID2}

export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD


LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J scn_convert_${PATTERN} -n 4 -M 16GB -o scn_convert_${PATTERN}.out \
	-e scn_convert_${PATTERN}.err -R 'select[mem>64MB] rusage[mem=16GB] span[hosts=1]' \
        -w $JOBID2 \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	"Rscript scripts/R_steps/R_scripts/convert.R $LEVEL $PATTERN $DATASET $SAMPLE $DESC $LINK $TOKEN $SPEC"