#!/bin/sh

# The workflow follows:
# 1) preprocess sources
# 2) compile them
# 3) compile original sources
# To the stdout the following is written:
# $path $prePackage $postPackage
# $files
# Author: Petr Belohlavek

path="."
srcDir="org/omp4j/benchmark/"

if [ $# -gt 1 ]; then
	printf "Usage: ./compile.sh [dir=.]\nwhere dir=path to benchmark dir. with src/ filled with sources to benchmark.\n"
	exit 1
elif [ $# -eq 1 ]; then
	path=$1
fi


cd $path
abstractBenchPath=$PWD/$srcDir/"AbstractBenchmark.java"
# TODO: assure $srcDir existence

# original files to be benchmarked
files=$(ls -d $PWD/$srcDir/*.java | grep -v "Abstract" | tr "\n" " ")

# preprocess & compile preprocessed sources into $binDir
omp4j -d $PWD -s $PWD $files $abstractBenchPath
