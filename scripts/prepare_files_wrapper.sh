#!/bin/bash

# enter vars
WD=$1
META=$2 #relative to WD
GSM_ACC=$3 #provide name

$WD/scripts/parse_accession.sh $WD $META $GSM_ACC
$WD/scripts/get_fastq_wrapper.sh $WD $GSM_ACC

