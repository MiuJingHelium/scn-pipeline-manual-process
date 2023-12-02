#!/bin/bash
STORAGE_ALLOCATION=martyomov
export CONDA_ENVS_DIRS="/storage1/fs1/${STORAGE_ALLOCATION}/Active/IndividualBackUps/carisa/conda/envs/"
export CONDA_PKGS_DIRS="/storage1/fs1/${STORAGE_ALLOCATION}/Active/IndividualBackUps/carisa/conda/pkgs/"

export LSF_DOCKER_VOLUMES="/storage1/fs1/${STORAGE_ALLOCATION}/Active:/storage1/fs1/${STORAGE_ALLOCATION}/Active /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"
export PATH="/opt/conda/bin:$PATH"

WD=$1
cd $WD
#ENV_FILE=$2

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -Is -q general-interactive -G compute-martyomov \
        -n 4 -o get_fastq_conda.out \
        -e get_fastq_conda.err -R 'rusage[mem=64GB] span[hosts=1]' \
	-J get_fastq_conda -M 64GB \
        -a "docker(continuumio/anaconda3)"  \
	/bin/bash -l
