WD=$1
GSM_ACC_list=$2
INDIR=$WD/info/

cd $WD
chmod +x scripts/preparation/get_fastq_conda.sh
mkdir -p fastq/
GSM="GSM7041007"
SRR_array=("SRR23444917")

for SRR in ${SRR_array[@]}
do
	if [ -d "${WD}/fastq/${GSM}/${SRR}" ]; then
		rm -r "${WD}/fastq/${GSM}/${SRR}" # clean up previous download
	fi
	$WD/scripts/preparation/get_fastq_conda.sh $WD $GSM $SRR 
done 
