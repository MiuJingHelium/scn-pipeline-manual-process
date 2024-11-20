#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
INDIR=$2
SAMPLE=$3
JOBID=$4
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J ${SAMPLE}_gzip -n 8 -M 2GB -o ${SAMPLE}_gzip.out \
	-e ${SAMPLE}_gzip.err \
	-w $JOBID \
        -a "docker(ubuntu)" /bin/bash -c \
	"gzip $INDIR/$SAMPLE/Solo.out/Gene/filtered/*; gzip $INDIR/$SAMPLE/Solo.out/Gene/raw/*"

