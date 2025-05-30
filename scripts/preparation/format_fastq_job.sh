#!/bin/bash

WD=$1
GSM_ACC=$2
SRR_ACC=$3
WHITELIST=$4


export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -n 4 -o "${GSM_ACC}_${SRR_ACC}_reformat.out" \
        -e "${GSM_ACC}_${SRR_ACC}_reformat.err" -R 'rusage[mem=32GB] span[hosts=1]' \
	-J "${GSM_ACC}_${SRR_ACC}_reformat" -M 32GB \
        -g /carisa/sra \
	-a "docker(continuumio/miniconda3)"  \
	/bin/bash -c \
	"conda init; source activate /storage1/fs1/martyomov/Active/IndividualBackUps/carisa/conda/envs/reformat-geo ; $WD/scripts/preparation/format_fastq.py $SRR_ACC $WD/fastq/$GSM_ACC/ $WHITELIST" 
