#!/bin/bash

#PROJECT=$1
#esearch -db sra -query $PROJECT | efetch -format runinfo > runinfo.csv
#cat runinfo.csv | cut -d "," -f 1 > SRR.numbers
SRR_ACC=$1
WD=$2 

#need to limit the number of jobs/request sobmitted
while read LINE
do
	prefetch --max-size u -O $WD/ $LINE
	parallel-fastq-dump -s $WD/$LINE/ --split-files --threads 4 --outdir $WD/$LINE/ --tmpdir $WD/$LINE/ --gzip 2>&1 > $WD/$LINE/parallel_fastq_dump.log
done < $SRR_ACC
#end while read
