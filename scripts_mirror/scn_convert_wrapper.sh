#!/bin/bash

WD=$1
cd $WD
chmod +x scripts/scn_convert_job.sh

SAMPLES=($(ls outs/align/))
DATASET="GSE198835"
DESC="info/GSE198835_description.txt"
LINK="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc="
SPECIES="mm"

for GSM in ${SAMPLES[@]};
do
	scripts/scn_convert_job.sh `pwd` "sample" $GSM $DATASET $GSM $DESC "${LINK}${GSM}" "${DATASET}_${GSM}" $SPECIES 	
done

scripts/scn_convert_job.sh `pwd` "dataset" $DATASET $DATASET $GSM $DESC "${LINK}${DATASET}" $DATASET $SPECIES
