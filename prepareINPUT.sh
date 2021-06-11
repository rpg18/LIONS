#! /bin/bash
proj=$1
meta=$2
path_bam=$3
path=$4
condition=$5
select=$6
#
# control sample list
group1=`grep $condition $meta | cut -d"$SEP" $select | xargs | sed -e "s/\n/\t/g"`
echo "grep $condition $meta | cut -d"$SEP" $select | xargs | sed -e "s/\n/\t/g""
#
# structure of input.list dataset file
for line in `ls -1 $path_bam`
do
	basename=`echo $line | cut -d'.' -f1`
#	echo $basename
	if echo $group1 | grep -w "$basename"
	then
		control+="$basename\t$path_bam/$line\t1\n"
	else
		treat+="$basename\t$path_bam/$line\t2\n"
	fi
done
#
# save output file
echo -e $control$treat| grep . > $path/controls/input_${proj}.list
#grep . intermediary.txt > $path/controls/input_${proj}.list
