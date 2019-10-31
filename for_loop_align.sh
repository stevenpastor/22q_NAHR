#!/bin/bash
#$ -N basic_align
#$ -S /bin/sh
#$ -wd /home/bionano/emanuel_workflows/to_alt_align_bnx
#$ -pe smp 56

ulimit -a
echo ${HOSTNAME}
date
export O64_OMP_SET_AFFINITY=false

# put names into a file called input.

while read line
do
SAMPLE="merged_1.3mbp"
REFNAME="341"
# Align SAMPLE.bnx to REF:
${TIME_BINARY:=/usr/bin/time} -f "%U	%S	%E	%P	%M" \
/home/bionano/tools/pipeline/1.0/RefAligner/1.0/RefAligner${BINARY_SUFFIX:=} -f \
-i $SAMPLE.bnx \
-ref $REFNAME.cmap \
-o $SAMPLE"_vs_"$REFNAME \
-M 3 3 -FP 0.918057 -FN 0.099062 -sf 0.233588 -sd 0.090609 -S 0 \
-minlen 120 \
-minsites 9 \
-T 1e-11 -res 3.5 -resSD 0.7 -Mfast 0 -biaswt 0 -A 5 -BestRef 1 -nosplit 2 \
-outlier 1e-5 -endoutlier 1e-5 \
-RAmem 3 30 -maxmem 224 -maxvirtmem 0 \
-hashgen 5 4 2.4 1.4 0.05 5.0 1 1 1 -hash -hashdelta 14 10 24 -hashoffset 1 -hashrange 1 -hashGC 300 -hashT2 1 -hashkeys 1 -hashMultiMatch 30 10 \
-insertThreads 56
# Clean-up:
rm -rf *maprate; rm -rf *errbin; rm -rf *err; rm -rf *intervals.txt; rm -rf *.map
done <input

