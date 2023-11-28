#!/bin/bash

WD=$1
cd $WD
INDIR=$2 #typically $WD/fastq/; directly under $WD

for SAMPLE in $(ls $INDIR);do
	FASTQ=("$INDIR/$SAMPLE/"*.fastq)
	for FILE in "${FASTQ[@]}";do
		echo "Compressing ${FILE}:"
		gzip ${FILE}
		echo "Compression finished."
	done
done

