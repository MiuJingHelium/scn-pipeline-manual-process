#!/bin/bash

# enter vars
WD=$1
META=$2 #relative to WD
GSM_ACC=$3 #provide name

cd $WD
chmod +x scripts/parse_accession.sh
chmod +x scripts/get_fastq_wrapper.sh  

$WD/scripts/parse_accession.sh $WD $META $GSM_ACC
$WD/scripts/get_fastq_wrapper.sh $WD $GSM_ACC

