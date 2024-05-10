#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
INDIR=$2
OUTDIR=$3
GSM=$4
INDEX_DIR=$5
WHITELIST_V3="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/3M-february-2018.txt" #v3 barcode
WHITELIST_V2="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/737K-august-2016.txt" #3' V2
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD
mkdir -p $OUTDIR/$GSM
#JOBID=$6
#ASSUME 10X
#If v2: soloCBlen=16; v3: soloCBlen=16
#if v2: soloUMIlen=10; v3: soloUMIlen=12
#This test case is v3. Deduced from sequence length (28).
#FASTQ_PREFIX=( $(ls -d $INDIR/$GSM/*) )
SRR=( $(ls $INDIR/$GSM/) )
n_file=($(ls $INDIR/$GSM/ -1 | wc -l))
for i in ${SRR[@]}; do 
	for ((n=0; n<$n_file;n++ ))
	do 
		FASTQ_3[n]="$INDIR/$GSM/$i/${i}_3.fastq.gz"
		FASTQ_2[n]="$INDIR/$GSM/$i/${i}_2.fastq.gz"
		FASTQ_1[n]="$INDIR/$GSM/$i/${i}_1.fastq.gz"
	
	done
done


#FASTQ_3=( ${${INDIR}$GSM$SRR_rep[@]/%/_3.fastq.gz} )
#FASTQ_2=( ${SRR_rep[@]/%/_2.fastq.gz} )
#FASTQ_1=( ${SRR_rep[@]/%/_1.fastq.gz} )

function join_by { local IFS="$1"; shift; echo "$*"; }
R_3=$(join_by , ${FASTQ_3[@]})
R_2=$(join_by , ${FASTQ_2[@]})
R_1=$(join_by , ${FASTQ_1[@]})
# For this make-up job, V2 alignment is performed instead of V3

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J ${GSM}_align -n 8 -M 64GB -o ${GSM}_align.out \
	-e ${GSM}_align.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/starsolo:2.7.10b)" STAR --genomeDir $INDEX_DIR \
        --readFilesIn  $R_2 $R_1 \
  	--clipAdapterType CellRanger4 --outFilterScoreMin 30 \
  	--soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR --soloUMIdedup 1MM_CR \
  	--soloCBlen 16 \
  	--soloUMIlen 10 \
  	--soloBarcodeReadLength 0 \
  	--soloType CB_UMI_Simple \
  	--soloCBwhitelist $WHITELIST_V2 \
  	--outFileNamePrefix "$OUTDIR/$GSM/" \
  	--runThreadN 8 \
  	--readFilesCommand zcat \
  	--outSAMtype BAM Unsorted

	#-w $JOBID \