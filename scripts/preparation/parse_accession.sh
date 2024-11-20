#!/bin/bash

# provide full path 
WD=$1
cd $WD
METADATA_TABLE=$2
GSM_ACC_NAME=$3
RUN_INDEX=1 # not used 
SAMPLE_INDEX=25 #not used
OUTDIR=$WD/info/
mkdir -p $OUTDIR

col_n=($(awk -F "," 'NR==1{ for (i=1; i<=NF; ++i) { if ($i=="Sample Name") print i } }' $METADATA_TABLE))
awk -v col=${col_n} -F "," 'NR>1{print $col }' $METADATA_TABLE | sort | uniq > $OUTDIR/$GSM_ACC_NAME
# if you want to assign GSM as a specific row of the GSM_ACC_list
# GSM=$(awk 'NR==1{print}' GSM_ACC_list.txt)

while read GSM
do 
	awk -F "," -v GSM=$GSM -v col=${col_n} 'NR>1{ if ($col == GSM) {print $1} else {next} }' $METADATA_TABLE > $OUTDIR/${GSM}_SRR_ACC_list.txt

done < $OUTDIR/$GSM_ACC_NAME
