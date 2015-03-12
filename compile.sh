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
prePackage="org.omp4j.benchmark.pre"
postPackage="org.omp4j.benchmark.post"
srcDir="src"
binDir="bin"

if [ $# -gt 1 ]; then
	printf "Usage: ./compile.sh [dir=.]\nwhere dir=path to benchmark dir. with src/ filled with sources to benchmark.\n"
	exit 1
elif [ $# -eq 1 ]; then
	path=$1
fi


cd $path
mkdir -pv $binDir
# TODO: assure $srcDir existence

# original files to be benchmarked
files=$(ls -d $PWD/$srcDir/*.java | tr "\n" " ")

# prepare pre-package
for f in $files; do
	sed -i "1ipackage $postPackage;" $f
done

# preprocess & compile preprocessed sources into $binDir
omp4j "-d $PWD/$binDir/ -- $files"

# prepare post-package
for f in $files; do
	sed -i "1 s/^.*$/package $prePackage;/g" $f
done

# compile original sources
javac -d $binDir $files

# remove package information
for f in $files; do
	sed -i "1d" $f
done
