#!/bin/bash

ACC_list=$1
ACC=$2 #ideally ACC should be extracted from file name
declare -i batch_n=1
declare -i counter=1
while read LINE
do
	if [ $counter -lt 4 ] 
	then
		echo $LINE >> ${ACC}_${batch_n}.txt
		counter+=1
	else
		batch_n+=1
		echo $LINE >> ${ACC}_${batch_n}.txt
		counter=1
	fi
done < $ACC_list
