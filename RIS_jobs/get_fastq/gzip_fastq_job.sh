#!/bin/bash
WD=$1
INDIR=$2
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD
chmod +x ./gzip_fastq.sh

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q general -G compute-martyomov \
	-J gzip_fastq -n 8 -M 64GB -o gzip_fastq.out \
	-e gzip_fastq.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
	-a "docker(ubuntu:bionic)" /bin/bash -c \
	"./gzip_fastq.sh $WD $INDIR"

