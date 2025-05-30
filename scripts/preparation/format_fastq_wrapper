#!/bin/bash
WD=$1
WHITELIST=$2
INDIR='fastq/'

chmod +x ./scripts/reformat_fastq_job.sh

cd $WD
for GSM in $(ls $INDIR);
do
	FILECOUNT=$(find $INDIR/$GSM -type f | wc -l)
	for SRR in $(ls $INDIR/$GSM); do
		# for each SRR submit one job
        # may need to optimize for job arrays
        if [ -f "${INDIR}/${GSM}/${SRR}/${SRR}.sra" ]; then
			rm ${INDIR}/${GSM}/${SRR}/${SRR}.sra
        fi

        if [ -f "${INDIR}/${GSM}/${SRR}/parallel_fastq_dump.log" ]; then
			rm ${INDIR}/${GSM}/${SRR}/parallel_fastq_dump.log
		fi
        ./scripts/reformat_fastq_job.sh $WD $GSM $SRR $WHITELIST# may consider additional arguments
	done
done

