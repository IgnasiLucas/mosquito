#!/bin/bash
#
#
#				2019-02-18
#
# In the course of Víctor's analyses, we noticed that the vcf result from
# crisp included non-printable characters, that made grep consider the vcf
# file binary. I found the characters were added in the field FLANKSEQ of the
# INFO section, when the variant was less than 10 bases from the beginning of
# the contig. I reported the bug, and crisp author, Vikas Bansal, replied
# immediately with a fix. He asked me to check if the fixed version works.

BAM_DIR=/data/victor/mosquito/data/asgharian/bam/bwa
SAMPLE=(1.molA1 2.pipA4 3.molM1 4.torM2 5.molS1 6.mixS2 7.mixS3 8.torM4)
ploidy=(41 41 52 56 30 26 41 41)
CRISP_DIR=/data/joiglu/bin/crisp
WORK_DIR=$(pwd)
VCF=/data/victor/mosquito/data/asgharian/vcf/crisp/culex_cohort.vcf
REF=/data/victor/mosquito/data/refgenome/CulQui.fna

if [ ! -e regions.bed ]; then
   # This finds non-printable ASCII characters. I don't have examples of variants too
   # close to the end of a contig.
   perl -nle 'print if m/[^ -~\t\r]/' $VCF | gawk '($2 < 11){print $1 "\t0\t200"}' | uniq > regions.bed
fi

touch bam_list.txt
for i in `seq 0 7`; do
   if [ ! -e ${SAMPLE[$i]}_test.bam ]; then
      samtools view -b -o ${SAMPLE[$i]}_test.bam -L regions.bed $BAM_DIR/${SAMPLE[$i]}.sort.RG.markdup.bam
   fi
   if ! grep -q ${SAMPLE[$i]}_test.bam bam_list.txt; then
      echo ${SAMPLE[$i]}_test.bam PS=${ploidy[$i]} >> bam_list.txt
   fi
done

if [ ! -e master.vcf ]; then
   cd $CRISP_DIR
      # I checkout a branch I created after adding -no-pie flag to Makefiles and compiling crisp.
      git checkout ignasi
   cd $WORK_DIR
   $CRISP_DIR/CRISP --bams bam_list.txt \
         --ref $REF \
         --VCF master.vcf \
         --minc 1 \
         --mbq 5 \
         --mmq 10 \
         --perms 30000 \
         --filterreads 0 \
         --qvoffset 33 \
         --EM 1 \
         --verbose 1
fi

if [ ! -e bugfix.vcf ]; then
   cd $CRISP_DIR
      git checkout bugfix
   cd $WORK_DIR
   $CRISP_DIR/CRISP --bams bam_list.txt \
         --ref $REF \
         --VCF bugfix.vcf \
         --minc 1 \
         --mbq 5 \
         --mmq 10 \
         --perms 30000 \
         --filterreads 0 \
         --qvoffset 33 \
         --EM 1 \
         --verbose 1
fi

# CONCLUSION
# ----------
#
# The bugfix branch did fix the problem. Now, only master.vcf includes non-printable characters.
