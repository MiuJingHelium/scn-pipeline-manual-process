#!/bin/bash

# enter vars
WD=$1
META=$2 #relative to WD
GSM_ACC=$3 #provide name
CHEMISTRY="" # v2 or v3
WHITELIST="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/3M-february-2018.txt"

# WHITELIST_V3="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/3M-february-2018.txt" #v3 barcode
# WHITELIST_V2="/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/CellRanger_barcodes/barcodes/737K-august-2016.txt" #3' V2
# whitelist is currently hardcoded; need to be optimized later.


cd $WD
chmod +x scripts/preparation/parse_accession.sh
chmod +x scripts/preparation/get_fastq_wrapper.sh  
chmod +x scripts/preparation/format_fastq_wrapper.sh 

# modidication: add additional step --> format_files.sh 
# the new wrapper script will be named as format_files.sh because
# not only fastq files need to be renamed; they need to be re-ordered 
# to make the read type evident.


$WD/scripts/preparation/parse_accession.sh $WD $META $GSM_ACC
$WD/scripts/preparation/get_fastq_wrapper.sh $WD $GSM_ACC

$WD/scripts/preparation/format_fastq_wrapper.sh $WD $CHEMISTRY
# for format_fastq, the accession may not be needed; accessions will be identified via list files.
