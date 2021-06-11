#!/bin/bash
# Script for running LIONS in three steps
# 1- Create input_PROJECT.list - locally
# 2- Run EAST-LIONS as qsub ARRAY job
# 3- RUN WEST-LIONS - qsub job (no ARRAY) or locally
echo 'starts LIONS...'

# PREPARE ARGUMENTS
# DIFFERENT FLAGS TO SPECIFIC UTILITIES
function usage {
	echo "Usage: $(basename $0) [-lEW]" 2>&1
        echo '   -l   prepares input list'	# CREATE INPUT.LIST
        echo '   -E   runs LIONS'		# RUN EAST-LIONS
	echo '   -W   runs LIONS'		# RUN WEST-LIONS
        exit 1
}

if [[ ${#} -eq 0 ]];then
	usage
fi

optstring=":lEW"

if [[ ${#} -eq 0 ]];then
        usage
fi

while getopts ${optstring} arg; do
  case "${arg}" in
    l) bash $path_script/prepareINPUT.sh $PROJECT $PATH_META $PATH_BAM $path $CONTROL $COLUMN
	echo "Preparing input list using prepareINPUT.sh" ;;
	#
    E) INPUT_LIST=$(sed "$PBS_ARRAYID"'q;d' $path/controls/input_${PROJECT}.list) 
	# EXTRACT SAMPLE NAME
	SAMPLE=$(echo $INPUT_LIST | cut -d' ' -f1 )
	echo $SAMPLE
	# CREATE INDIVIDUAL INPUT_SAMPLE.LIST PER SAMPLE
	echo $INPUT_LIST > "$path/controls/input_${SAMPLE}.list"
	# RUN EAST_LIONS
	bash $path/lions.sh $path/controls/parameter.ctrl $SAMPLE $PROJECT
	sleep 20
	echo "Finished EAST-LIONS job for $SAMPLE with $PBS_ARRAYID ID" ;;
	#
	W) INPUT_LIST="$path/controls/input_${PROJECT}.list"
	# RUN WEST_LIONS
	bash $path/scripts/westLion.sh $path_out/projects/$PROJECT $path/controls/input_${PROJECT}.list $path/controls/parameter.ctrl
	sleep 2
	echo "Finished WEST-LIONS job for $PROJECT" ;; #with $PBS_ARRAYID ID" ;;
	#
    ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done
#
# option_lions.sh
