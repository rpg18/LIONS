#!/bin/bash
#PBS -N uc-east-string-R.out
#PBS -e uc-east-string-R.error
#PBS -l walltime=35:00:00
#PBS -l vmem=65gb
#PBS -l nodes=1:ppn=12
#PBS -m bea
#PBS -V
#PBS -M rpg20@leicester.ac.uk 
#PBS -t 1-72
# 4,6,12,14,18,22,34,57,61,65,68
#(Check PBS -t is selected, but not for -W)
#
# PROJECT -- EDIT --
# --
set -a
path_script="/data/colorect/HOPE/SCRIPTS/LIONS"
path="$path_script/LIONS"
dataset="UC"
PROJECT="UC"
CONTROL="uninflamed"
#BAM_SUFFIX=".bam"
SEP=","
COLUMN="-f1" # select number of column to identify sample name
HG="hg38"
# --
#
# FOLDERS
# East-LIONS + RNAseq Pipeline Analysis + ChimericReadTool
path_out="/scratch/colorect/rpg20/NEW/DATASETS/POST_RAW/$dataset/LIONS"
path_option="/data/colorect/HOPE/SCRIPTS/LIONS/option_lions.sh"
mkdir -pv $path_out/tmp
export TMPDIR=$path_out/tmp
cd $path_out
PATH_META="/data/colorect/HOPE/$dataset/METADATA/metadata_${PROJECT}.txt" # path to metadata CSV file
PATH_BAM="/data/colorect/HOPE/$dataset/BAM" # path to bam file
#
set +a
#
# SET ENVIRONMENT
source $(conda info --base)/bin/activate
conda activate LIONS
#
# REQUIRED SOFTWARES
module load bowtie2/2.3.5.1
module load 'R/3.5.1'
module load bedtools/2.25.0
#
#
# RUN LIONS: -l = generate input list; -E run east-lions; -W run west-lions: run in order:
#bash $path_option -l
bash $path_option -E
#bash $path_option -W
