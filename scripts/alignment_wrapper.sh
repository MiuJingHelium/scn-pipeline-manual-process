#!/bin/bash

WD=$1
INDIR=$2 #absolute path to list of directories named by samples;typically named as fastq/
OUTDIR=$3 #typically outs/align/
#REF_FASTA='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/refdata-cellranger-mm10-3.0.0/fasta/genome.fa'
#REF_GTF='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/refdata-gex-mm10-2020-A/genes/genes.gtf'
INDEX_DIR='/storage1/fs1/martyomov/Active/References/10X/SC/Human/STAR_2.7.10b/'
cd $WD
mkdir -p $OUTDIR
# The index should have been generated inside the storage
# Because the reference is likely to be used multiple times, it is better to store it inside the storage
# and avoid repetitively generating it.

#chmod +x ./generate_index.sh
chmod +x ./scripts/align_task.sh
chmod +x ./scripts/gzip_outs.sh
#JOBID=$(./generate_index.sh $WD $REF_FASTA $REF_GTF $INDEX_DIR | awk '{print $2}' | tr -d '<>') 
for SAMPLE in $(ls $INDIR);do
	JOBID=$(./scripts/align_task.sh $WD $INDIR $OUTDIR $SAMPLE $INDEX_DIR | awk '{print $2}' | tr -d '<>') #$JOBID
	./scripts/gzip_outs.sh $WD $OUTDIR $SAMPLE $JOBID
	
done
