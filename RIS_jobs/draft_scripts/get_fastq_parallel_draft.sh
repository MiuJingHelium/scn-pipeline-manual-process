#!/bin/bash

INFILE=SRR_ACC_List_GSE186821.txt
mkdir -p logs
LOG=logs/get_fastq_dump_files.log
mkdir -p fastq
while read LINE
do
	wd=fastq/"${LINE}"/
	#echo "$wd"
	mkdir -p "$wd"
	parallel-fastq-dump -s $LINE --split-files --threads 4 --outdir $wd --tmpdir ./ --gzip 2>&1 > $LOG
	
done < "$INFILE"
