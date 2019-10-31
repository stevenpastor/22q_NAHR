#!/bin/bash
#$ -N fl_iter_align
#$ -S /bin/sh
#$ -wd /home/bionano/emanuel_workflows/to_iter_align_bnx
#$ -pe smp 56
#$ -j y

ulimit -a
echo ${HOSTNAME}
date
export O64_OMP_SET_AFFINITY=false

mkdir -p ./DONE

for i in *bnx
do
BNX=$(echo $i | cut -d'.' -f1)
SAMPLE=$BNX"_ITER_ALIGN"
#REF="allbut22"
#REF="allbut8"
#REF="allbut7"
REF="chr7"
mkdir -p $SAMPLE
# Align BNX to all ref chrs but chrNUM:
${TIME_BINARY:=/usr/bin/time} -f "%U	%S	%E	%P	%M" \
/home/bionano/tools/pipeline/1.0/RefAligner/1.0/RefAligner${BINARY_SUFFIX:=} -f \
-i $BNX.tmp.bnx \
-ref $REF.cmap \
-o $SAMPLE/TEST \
-M 3 3 -FP 0.918057 -FN 0.099062 -sf 0.233588 -sd 0.090609 -S 0 \
-minlen 200 \
-minsites 15 \
#-T 1e-25 -res 3.5 -resSD 0.7 -Mfast 0 -biaswt 0 -A 5 -BestRef 0 -nosplit 2 \
-T 1e-11 -res 3.5 -resSD 0.7 -Mfast 0 -biaswt 0 -A 5 -BestRef 0 -nosplit 0 \
#-outlier 1e-7 -endoutlier 1e-7 \
-outlier 1e-3 -endoutlier 1e-3 \
-RAmem 3 30 -maxmem 224 -maxvirtmem 0 \
-hashgen 5 4 2.4 1.4 0.05 5.0 1 1 1 -hash -hashdelta 14 10 24 -hashoffset 1 -hashrange 1 -hashGC 300 -hashT2 1 -hashkeys 1 -hashMultiMatch 30 10 \
-insertThreads 56

# Skip IDs:
#grep -v "#" $SAMPLE/TEST.xmap | cut -f2 | sort | uniq | sort -k1n > $SAMPLE/$BNX.IDs
#/home/bionano/tools/pipeline/1.0/RefAligner/1.0/RefAligner${BINARY_SUFFIX:=} -f \
#-maxthreads 56 \
#-maxmem 224 -merge -bnx -skipidf $SAMPLE/$BNX.IDs -i $BNX.tmp.bnx -o $SAMPLE/$BNX.sub
#mv $i ./DONE
#mv $SAMPLE/ ./DONE
done

