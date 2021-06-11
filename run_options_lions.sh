#!/bin/bash
#PBS -N .out
#PBS -e .error
#PBS -l walltime=?:00:00
#PBS -l vmem=?gb
#PBS -l nodes=1:ppn=?
#PBS -m bea
#PBS -V
#PBS -M email@email.com 
#PBS -t 1-X
#(Check PBS -t is selected)
#(Do not add -t for -W option - WEST-LIONS -)
#
# PROJECT -- EDIT --
# --
set -a
path_script="/..." # where LIONS folder is found
path="$path_script/LIONS"
dataset=""
PROJECT=""
CONTROL="" # control condition as specified in metadata file
SEP="" # metadata format file (e.g., "," or "\t"
COLUMN="-fX" # select number of column to identify sample name (e.g., "-f1")
HG="hg38"
# --
#
# FOLDERS
# East-LIONS + RNAseq Pipeline Analysis + ChimericReadTool
path_out="/.../$dataset/LIONS"
path_option="/.../option_lions.sh"
mkdir -pv $path_out/tmp
export TMPDIR=$path_out/tmp
cd $path_out
PATH_META="/.../$dataset/METADATA/metadata_${PROJECT}.txt" # path to metadata CSV file
PATH_BAM="/.../$dataset/BAM" # path to bam file
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
bash $path_option -l 	#1
#bash $path_option -E	#2
#bash $path_option -W	#3
