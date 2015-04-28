#!/bin/sh

make

for threadNum in $(seq 1 48); do
	OMP_NUM_THREADS=$threadNum ./fibonacci
done
