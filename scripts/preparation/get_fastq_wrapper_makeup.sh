WD=$1

cd $WD
chmod +x scripts/preparation/get_fastq_conda.sh
mkdir -p fastq/
GSM="GSM6911596"
SRR_array=("SRR22950310")

for SRR in ${SRR_array[@]}
do
	if [ -d "${WD}/fastq/${GSM}/${SRR}" ]; then
		rm -r "${WD}/fastq/${GSM}/${SRR}" # clean up previous download
	fi
	$WD/scripts/preparation/get_fastq_conda.sh $WD $GSM $SRR 
done 
