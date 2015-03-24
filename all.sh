#!/bin/sh

# Run generate.sh, compile.sh and benchmark.sh
# Author: Petr Belohlavek

path="."
resDir="resources"

if [ $# -eq 1 ]; then
	path=$1
else
	printf "Usage: ./all.sh <dir>\nwhere dir=path root benchmark directory.\n"
	exit 1
fi

mkdir -p $path

./generate.sh $path
./compile.sh $path
./benchmark.sh $path
