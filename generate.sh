#!/bin/sh

# Generate various settings for Java classes in $resDir directory.
# Author: Petr Belohlavek

path="."
resDir="resources"
refDir=$resDir/"reference"
srcDir="org/omp4j/benchmark/"
abstractBenchPath="./org/omp4j/benchmark/"

if [ $# -gt 1 ]; then
	printf "Usage: ./generate.sh [dir=.]\nwhere dir=path to benchmark dir.\n"
	exit 1
elif [ $# -eq 1 ]; then
	path=$1
fi

mkdir -p $path/$srcDir

# original files
cd $resDir
files=$(ls *.java | tr "\n" " ")
cd ..

timeout=20	# "work" timeout

for f in $files; do
	oldClassName=$(echo $f | sed 's/\.java$//')

	for schedule in "dynamic"; do # "static"	# schedule type
	for threadNum in $(seq 1 48); do	# number of threads

		className="$oldClassName"_"$threadNum"_"$schedule"
		ff=$path/$srcDir/$className.java
		cp $resDir/$f $ff

		sed -i "s/!threadNum!/$threadNum/g" $ff
		sed -i "s/!schedule!/$schedule/g" $ff
		sed -i "s/$oldClassName/$className/g" $ff
	done
	done
done

cp $abstractBenchPath/"AbstractBenchmark.java" $path/$srcDir/AbstractBenchmark.java
