#!/bin/bash
WD=$1
INDIR='fastq/'
cd $WD
for GSM in $(ls $INDIR);
do
	for SRR in $(ls $INDIR/$GSM);
	do
		if [ -f "${INDIR}/${GSM}/${SRR}/${SRR}_3.fastq.gz" ]; then
			mv ${INDIR}/${GSM}/${SRR}/${SRR}_3.fastq.gz ${INDIR}/${GSM}/${SRR}/${SRR}_S1_R1_001.fastq.gz
		fi
		if [ -f "${INDIR}/${GSM}/${SRR}/${SRR}_4.fastq.gz" ]; then
			mv ${INDIR}/${GSM}/${SRR}/${SRR}_4.fastq.gz ${INDIR}/${GSM}/${SRR}/${SRR}_S1_R2_001.fastq.gz
		fi
		if [ -f "${INDIR}/${GSM}/${SRR}/parallel_fastq_dump.log" ]; then
			rm ${INDIR}/${GSM}/${SRR}/parallel_fastq_dump.log
		fi
		if [ -f "${INDIR}/${GSM}/${SRR}/${SRR}.sra" ]; then
			rm ${INDIR}/${GSM}/${SRR}/${SRR}.sra
		fi
	done
done
