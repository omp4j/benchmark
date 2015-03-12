#!/bin/sh

# Generate various settings for Java classes in $resDir directory.
# Author: Petr Belohlavek

path="."
resDir="resources"
srcDir="src"

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

for f in $files; do

	oldClassName=$(echo $f | sed 's/\.java$//')

	for n in 100 1000 10000; do
		for schedule in "dynamic" "static"; do
			for threadNum in 1 2 3 4; do

				className="$oldClassName"_"$threadNum"_"$n"_"$schedule"
				ff=$path/$srcDir/$className.java
				cp $resDir/$f $ff

				sed -i "s/!threadNum!/$threadNum/g" $ff
				sed -i "s/!N!/$n/g" $ff
				sed -i "s/!schedule!/$schedule/g" $ff
				sed -i "s/$oldClassName/$className/g" $ff
			done
		done
	done
done
