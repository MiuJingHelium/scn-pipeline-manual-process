#!/bin/bash

# enter vars
WD=$1
META=$2 #relative to WD
GSM_ACC=$3 #provide name

cd $WD
chmod +x scripts/preparation/parse_accession.sh
chmod +x scriptspreparation/get_fastq_wrapper.sh  

$WD/scripts/preparation/parse_accession.sh $WD $META $GSM_ACC
$WD/scripts/preparation/get_fastq_wrapper.sh $WD $GSM_ACC

# modidication: add additional step --> rename_files.sh