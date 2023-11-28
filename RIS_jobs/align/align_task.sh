#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
INDIR=$2
OUTDIR=$3
NAME=$4
WHITELIST="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/3M-february-2018.txt"
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD
mkdir -p $OUTDIR
INDEX_DIR=$5
#JOBID=$6
#ASSUME 10X
#If v2: soloCBlen=16; v3: soloCBlen=16
#if v2: soloUMIlen=10; v3: soloUMIlen=12
#This test case is v2. Deduced from sequence length (26).
LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q general -G compute-martyomov \
        -J ${NAME}_align -n 8 -M 64GB -o ${NAME}_align.out \
	-e ${NAME}_align.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/starsolo:2.7.10a)" STAR --genomeDir $INDEX_DIR \
        --readFilesIn "$INDIR/$NAME/${NAME}_2.fastq.gz" "$INDIR/$NAME/${NAME}_1.fastq.gz" \
  	--clipAdapterType CellRanger4 --outFilterScoreMin 30 \
  	--soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR --soloUMIdedup 1MM_CR \
  	--soloCBlen 16 \
  	--soloUMIlen 10 \
  	--soloBarcodeReadLength 0 \
  	--soloType CB_UMI_Simple \
  	--soloCBwhitelist $WHITELIST \
  	--outFileNamePrefix "$OUTDIR/$NAME/" \
  	--runThreadN 8 \
  	--readFilesCommand zcat \
  	--outSAMtype BAM Unsorted

	#-w $JOBID \
