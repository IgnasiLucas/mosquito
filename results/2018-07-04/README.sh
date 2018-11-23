#!/bin/bash
#
#				2018-07-04
#				==========
#
# Víctor has mapped Asgharian et al's reads to the Culex quinquefasciatus
# reference genome with both bowtie2 and bwa. Results are different. Here,
# I want to plot the coverage distributions for each pool.

DATADIR=`pwd | sed "s/results/data/"`
BWA_STATS=/data/victor/mosquito/results/2018-06-01/bwa
BT2_STATS=/data/victor/mosquito/results/2018-06-01/bt2

for i in `seq 27 34`; do
   if [ ! -e bwa$i.cov ]; then
      grep ^COV $BWA_STATS/SRR20296$i.stats | cut -f 2- > bwa$i.cov
   fi

   if [ ! -e bt2$i.cov ]; then
      grep ^COV $BT2_STATS/SRR20296$i.stats | cut -f 2- > bt2$i.cov
   fi
done

if [ ! -e coverage.png ]; then
   gnuplot < plot_coverage.gnp
fi
