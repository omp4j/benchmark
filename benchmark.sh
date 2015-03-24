#!/bin/sh

# Author: Petr Belohlavek

path="."
srcDir="org/omp4j/benchmark/"
package="org.omp4j.benchmark"

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
files=$(ls -d $PWD/$srcDir/*.java | grep -v "Abstract" | tr "\n" " ")

# prepare pre-package
cd $currPath
CLASSPATH=$path":"$CLASSPATH

for f in $files; do
	className=$(echo $f | sed 's/\.java$//' | sed 's|^.*/||g' | tr "/" ".")

	# for workload in $(seq 10 10 100); do
	for workload in 50 75 100 500 1000 3000 7000 10000; do
		printf "Benching file %s with workload=%s\n" $f $workload >&2
		java $benchmarker $package"."$className $workload
	done
done
