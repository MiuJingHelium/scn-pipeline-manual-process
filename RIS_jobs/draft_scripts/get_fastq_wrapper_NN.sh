#!/bin/bash
#BSUB -n 4
#BSUB -q martyomov
#BSUB -G compute-martyomov
#BSUB -o get_fastq_sra.out
#BSUB -e get_fastq_sra.err
#BSUB -R 'rusage[mem=32GB] span[hosts=1]'
#BSUB -J get_fastq_sra
#BSUB -M 32GB
#BSUB -a "docker(ubuntu)"

INFILE=SRR_Acc_GSE221533.txt
#export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"
cd $PWD
echo $INFILE
#LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
#	-g /carisa/sra -n 1 -o get_fastq.out \
#	-e get_fastq.err -R 'rusage[mem=32GB] span[hosts=1]' \
#	-J get_fastq -M 32GB \
#	-a "docker(ubuntu)"  /bin/bash -c \
#	"./get_fastq.sh $INFILE $PWD"
