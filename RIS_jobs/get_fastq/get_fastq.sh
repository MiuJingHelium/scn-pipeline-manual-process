#!/bin/bash

INFILE=$1
WD=$2 #WD needs to be an absolute path
cd $WD
#mkdir -p logs
#LOG=$PWD/logs/get_fastq_dump_files.log
#mkdir -p fastq
while read LINE
do
	#WD=fastq/"${LINE}"/
	#WD=fastq/$LINE/fastq/$LINE/$LINE/
	#echo "$WD" >> lines.txt
	mkdir -p "$WD/fastq/"
	JOBID=$(./prefetch.sh ${WD} "$WD/fastq/" $LINE | awk '{print $2}' | tr -d '<>')
	#sleep 1
	./fasterq_dump.sh ${WD} "$WD/fastq/" $LINE $JOBID
done < "$INFILE"
