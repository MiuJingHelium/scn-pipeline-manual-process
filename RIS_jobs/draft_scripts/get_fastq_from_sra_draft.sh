#!/bin/bash

WD=$1
LINE=$2
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"


cd $WD

#current_time=$(date "+%Y.%m.%d-%H.%M.%S")
#export P_LOG="/scratch1/fs1/martyomov/carisa/logs/$current_time.log"

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -n 4 -o get_fastq_sra.out \
        -e get_fastq_sra.err -R 'rusage[mem=32GB] span[hosts=1]' \
	-J get_fastq_sra -M 32GB \
        -a "docker(ncbi/sra-tools)"  \
	prefetch "$LINE" -O "$WD" --max-size u	

