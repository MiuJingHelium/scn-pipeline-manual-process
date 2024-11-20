#!/bin/bash

WD=$1
INDIR=$2 #absolute path to list of directories named by samples;typically named as fastq/
OUTDIR=$3 #typically outs/align/
MODE=$4
#REF_FASTA='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/refdata-cellranger-mm10-3.0.0/fasta/genome.fa'
#REF_GTF='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/refdata-gex-mm10-2020-A/genes/genes.gtf'
# INDEX_DIR='/storage1/fs1/martyomov/Active/References/10X/SC/Human/STAR_2.7.10b/'
INDEX_DIR='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/STAR_2.7.10b/'


cd $WD

# The index should have been generated inside the storage
# Because the reference is likely to be used multiple times, it is better to store it inside the storage
# and avoid repetitively generating it.

#chmod +x ./generate_index.sh
chmod +x ./scripts/alignment/align_task.sh
chmod +x ./scripts/alignment/align_task_cellranger.sh
chmod +x ./scripts/alignment/gzip_outs.sh
#JOBID=$(./generate_index.sh $WD $REF_FASTA $REF_GTF $INDEX_DIR | awk '{print $2}' | tr -d '<>') 
case "$MODE" in 
	"cellranger")
		./scripts/preparation/rename_fastq.sh $WD
		for SAMPLE in $(ls $INDIR);do
		JOBID=$(./scripts/alignment/align_task_cellranger.sh $WD $INDIR $OUTDIR $SAMPLE $INDEX_DIR | awk '{print $2}' | tr -d '<>') #$JOBID
		#./scripts/gzip_outs.sh $WD $OUTDIR $SAMPLE $JOBID
	
	done
	;;
	"star")
		mkdir -p $OUTDIR
		for SAMPLE in $(ls $INDIR);do
			JOBID=$(./scripts/alignment/align_task.sh $WD $INDIR $OUTDIR $SAMPLE $INDEX_DIR | awk '{print $2}' | tr -d '<>') #$JOBID
			./scripts/alignment/gzip_outs.sh $WD $OUTDIR $SAMPLE $JOBID
	
		done
	;;
esac	
