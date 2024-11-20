#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
INDIR=$2
OUTDIR=$3
GSM=$4
GENOME=$5
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

WHITELIST="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/3M-february-2018.txt"

case "$GENOME" in
	"hs")
		REF_DIR='/storage1/fs1/martyomov/Active/References/10X/SC/Human/refdata-cellranger-GRCh38-3.0.0/'
	;;
	"mm")
		REF_DIR='/storage1/fs1/martyomov/Active/References/10X/SC/Mouse/refdata-cellranger-mm10-3.0.0/'
	;;
esac


cd $WD
mkdir -p $OUTDIR/$GSM

# path to fastq can take multiple comma-separated paths
function join_by { local IFS="$1"; shift; echo "$*"; } # need test
SRR=( $(ls $INDIR/$GSM/) )
SRR_PATH=( $(ls -d $INDIR/$GSM/*) ) # need test
FASTQ_PATH=$(join_by , ${SRR_PATH[@]})
SAMPLE=$(join_by , ${SRR[@]})

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J ${GSM}_align -n 8 -M 64GB -o ${GSM}_align.out \
	-e ${GSM}_align.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/cellranger:v7.2.0)" /bin/bash -c "cellranger count --id $GSM \
        --output-dir $OUTDIR/$GSM \
        --sample $SAMPLE \
        --transcriptome $REF_DIR \
        --fastqs $FASTQ_PATH \
        --localmem=64 \
        --localcores=16"

	#-w $JOBID \