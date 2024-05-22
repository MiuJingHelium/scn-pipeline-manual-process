#!/bin/bash

WD=$1
DATASET=$2
DESC=$3
LINK=$4
SPECIES=$5
JOBID2=$6
# echo $JOBID2 ; correctly passed

cd $WD
chmod +x scripts/R_steps/scn_convert_job.sh

SAMPLES=($(ls outs/align/))


for GSM in ${SAMPLES[@]};
do
    #echo ${JOBID2}_"sample"
	scripts/R_steps/scn_convert_job.sh `pwd` "sample" $GSM $DATASET $GSM $DESC "${LINK}${GSM}" "${DATASET}_${GSM}" $SPECIES $JOBID2	
done
#echo ${JOBID2}_"dataset"
scripts/R_steps/scn_convert_job.sh `pwd` "dataset" $DATASET $DATASET $GSM $DESC "${LINK}${DATASET}" $DATASET $SPECIES $JOBID2