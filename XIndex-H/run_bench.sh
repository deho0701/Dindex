#!/bin/bash

READ_ratio="0.5"
INSERT_ratio="0.3"
REMOVE_ratio="0.2"

CORE_START=4
CORE_END=100
DISTANCE_CORE=4

TABLE_SIZE=1000

chmod +x run_bench.sh
chmod -R 777 test-result


echo 'write a version and message'
read version message

echo "version : $version , read : $READ_ratio , insert : $INSERT_ratio , remove : $REMOVE_ratio, table size: $TABLE_SIZE" 
echo "read : $READ_ratio , insert : $INSERT_ratio , remove : $REMOVE_ratio , table size : $TABLE_SIZE"> $version-result.csv
echo 'message: '$message >>$version-result.csv

#echo 'thread num: ' 1 >>$version-result.csv
#./microbench --read 0.9 --insert 0.05 --remove 0.05 --table-size 100000 --fg 1 | tail -n 1 >>$version-result.csv


for fg_n in `seq $CORE_START $DISTANCE_CORE $CORE_END`
do 
	echo 'doing thread: ' $fg_n
	echo 'thread num: ' $fg_n >>$version-result.csv
	./microbench --read $READ_ratio --insert $INSERT_ratio --remove $REMOVE_ratio --table-size $TABLE_SIZE --fg $fg_n | tail -n 1 >>$version-result.csv
	
	#check for dead CPU
	check=$(tail $version-result.csv -n 1)
	
	while [ "$check" == *"Throughput"* ]
	do 
		echo 'do it again thread:' $fg_n
		echo $check
		sed '$ d' -i $version-result.csv  #del last line
		./microbench --read $READ_ratio --insert $INSERT_ratio --remove  $REMOVE_ratio --table-size $TABLE_SIZE --fg $fg_n | tail -n 1 >>$version-result.csv
		check=$(tail $version-result.csv -n 1)
	done	
done

chmod -R +x $version-result.csv

mv $version-result.csv ./test-result


