#!/bin/bash

WD=$1
OUTDIR=$2 #Typically $WD/fastq/
LINE=$3
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"                                                                           
JOBID=$4

cd $WD

#current_time=$(date "+%Y.%m.%d-%H.%M.%S")
#export P_LOG="/scratch1/fs1/martyomov/carisa/logs/$current_time.log"

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -g /carisa/sra -n 4 -o get_fastq_${LINE}.out \
        -e get_fastq_${LINE}.err -R 'rusage[mem=64GB] span[hosts=1]' \
	-J get_fastq_${LINE} -M 64GB \
	-w "done($JOBID)" \
	-a "docker(ncbi/sra-tools)"  \
	fasterq-dump --split-files --outdir "$OUTDIR/$LINE/" $LINE	
