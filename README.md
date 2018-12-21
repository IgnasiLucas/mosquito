# Mosquito
This is a re-analysis of some preliminary sequence data from Culex pipiens
form pipiens and form molestus. Individual samples were sequenced at a very
shallow depth. Previous analyses showed a quite low level of mapping success
to the reference genome of Culex quinquefasciatus. Chimeric reads are suspected
to be frequent.

The goal is to compare the two ecotypes.

## 2017-08-29
Here, I use the reads from Asgharian et al. (2015) selected on 2017-08-04 to
map them against the consensus sequences of the loci assembled by ipyrad from
our dataset.

## 2017-08-04
Asgharian et al.'s reads need to be mapped to the consensus sequences of selected
loci in local mode. That is, allowing for partial alignments, since reads are
expected to extend beyond the loci often. The problem then is that many spurious
partial alignments confound the true genotypes of the sequenced individual at
those loci. In this folder, I use the Culex quinquefasciatus reference genome
to first locate the selected loci in the genome, and then filter out the reads
from the Asgharian et al. dataset that map anywhere else in that reference genome.
I reduce the number of reads from Culex pipiens samples to about 35%, and those
from C. torrentium to about 58%.

## 2017-07-19
Since freebayes throws an error, and the bug is to be solved, I resorted to use
bcftools to genotype the samples sequenced by Asgharian et al. at the loci selected
before.

## 2017-07-14
Attempt to get a consensus sequence (or pair of haplotypes) for each mosquito
sequenced by Asgharian et al. (2015) at loci assembled before with ipyrad. I
tried to use freebayes, to take advantage of a script made available by Michael
G. Harvey, and because I trust freebayes' algorithm. However, there is an issue
(#390) preventing me from using freebayes for the moment.

## 2017-05-30
I use the 261 loci assembled by ipyrad on 2016-11-22 to build a reference set
of loci. Then I download reads from other sequencing projects of Culex pipiens
and align them to those loci.

## 2016-12-20
Given the low coverage in the form pipiens, I pool their reads and repeat the
freebayes analysis to identify potentially diagnostic markers.

## 2016-11-22
Here I run ipyrad without using the reference genome of Culex quinquefasciatus,
to compare the results with the alternative approach of mapping the reads to that
reference. I set it up to run in a cluster, but after a few months in queue, I
resort to run it locally in avalon.

## 2016-07-26
We subsampled molestus reads and used pyrad to cluster the reads under different
similarity thresholds. The results suggest that a similarity threshold of 95%
provides the highest coverage per cluster, before dropping abruptly. However, the
fact that the number of clusters increase steadily suggests extensive paralogy
problems.

## 2016-07-25
Here we generate an alternative vcf file with Freebayes, instead of samtools'
mpileup (2016-07-12). Freebayes is much more flexible, newer, and probably better.

## 2016-07-21
First attempt to run pyrad. Very few reads, available, though. In any case, this is
deprecated, since we should be using ipyrad.

## 2016-07-12
We used samtools mpileup to generate the vcf. A first look at the distribution of
configurations suggests that the low coverage among pipiens samples precludes any
attempt at guessing genotypes, and it seems that in most sites only one or very few
individuals have any coverage. The situation is better for the molestus samples.
I need to revise the version of samtools used, which may affect the vcf.

## 2016-07-08
We used bowtie2 to map the merged reads to the reference genome of Culex quinquefasciatus.
They map better under local settings. Around 94% of molestus reads are mapped (only
25% unambiguously, though), while only 64% of pipiens reads map at all (only 16%
unambiguously). A possibility is to map the original paired ends as independent
reads, to allow for chimeric reads to map better. This would involve changing the
names of the reads, and it is not done, yet.

## 2016-07-06b
Now we check for the presence of adapters and trim them with Cutadapt. Read pairs
that have been successfully merged by PEAR are not expected to contain adapters
in 3' ends. Indeed, no more than 0.1% of reads seem to have (spurious?) traces of
adapters.

## 2016-07-06
We run SABRE to demultiplex the original fastq files, and PEAR, to merge the
paired reads that overlap. Both molestus and pipiens samples are processed. Less
than 10% of reads fail to be assinged to any sample. More than 95% of identified
pairs of reads merge. It is likely that many or most of those pairs that do not
merge fail to merge because of lower quality. It is safe to disregard non-merged
reads and work only with the assembled subset from now on.

