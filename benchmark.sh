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
prePath=$(echo $prePackage | tr "." "/")
postPath=$(echo $postPackage | tr "." "/")
benchmarker="org.omp4j.benchmark.Benchmark"
benchmarkerFile=$(echo $benchmarker | tr "." "/").java

if [ $# -gt 1 ]; then
	printf "Usage: ./benchmark.sh [dir=.]\nwhere dir=path root directory of compiled classes.\n"
	exit 1
elif [ $# -eq 1 ]; then
	path=$1
fi

currPath=$(pwd)

# compile Benchmark.java
javac $benchmarkerFile

cd $path
# original files to be benchmarked
cd $prePath
files=$(ls *.class | tr "\n" " ")
cd $path

# prepare pre-package
cd $currPath
CLASSPATH=$path":"$CLASSPATH
for f in $files; do
	className=$(echo $f | sed "s/\.class//")
	# echo $className

	java $benchmarker $prePackage.$className
	java $benchmarker $postPackage.$className
done
