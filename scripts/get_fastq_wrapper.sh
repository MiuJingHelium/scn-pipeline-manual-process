WD=$1
GSM_ACC_list=$2
INDIR=$WD/info/
cd $WD
mkdir -p fastq/
while read GSM
do
	mkdir -p fastq/$GSM
	SRR_ACC_list=${GSM}_SRR_ACC_list.txt
	while read SRR
	do
		$WD/scripts/get_fastq_conda.sh $WD $GSM $SRR 
	done < $INDIR/$SRR_ACC_list
done < $INDIR/$GSM_ACC_list
