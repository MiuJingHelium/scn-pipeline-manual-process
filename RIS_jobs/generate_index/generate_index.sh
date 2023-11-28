#!/bin/sh



WD=$1
REF_FASTA=$2
REF_GTF=$3
INDEX_DIR=$4

export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD
LOG="$WD/generate_index.log"

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q general -G compute-martyomov \
        -J STAR_generate_index10b -n 8 -M 64GB -o STAR_generate_index10b.out \
        -e STAR_generate_index10b.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/starsolo:2.7.10b)" /bin/bash -c "STAR --runMode genomeGenerate --genomeDir $INDEX_DIR \
  	--genomeFastaFiles $REF_FASTA --sjdbGTFfile $REF_GTF \
  	--runThreadN 8 2> $LOG"
