#!/bin/bash

#PROJECT=$1
#esearch -db sra -query $PROJECT | efetch -format runinfo > runinfo.csv
#cat runinfo.csv | cut -d "," -f 1 > SRR.numbers
SRR=$1
OUTDIR=$2 


prefetch --max-size u -O $OUTDIR/ $SRR
parallel-fastq-dump -s $OUTDIR/$SRR/ --split-files --threads 4 --outdir $OUTDIR/$SRR/ --tmpdir $OUTDIR/$SRR/ --gzip 2>&1 > $OUTDIR/$SRR/parallel_fastq_dump.log