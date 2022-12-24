#!/usr/bin/bash -l
#SBATCH -p intel -N 1 -n 24 --mem 96gb --out logs/pilon.%a.log --array 1-12

module load AAFTF
MEM=96
SAMPLES=nanopore_samples.csv     #定义样本文件
INDIR=asm/medaka                 #输入文件的路径，本脚本是利用pilon软件对canu组装后并且经过medaka软件自我修正后的文件作为目标文件
OUTDIR=asm/pilon                 #输出文件的路径
READDIR=input/illumina           #读取文件的路径，本脚本是利用illumina数据对canu组装后并且经过medaka软件自我修正后的文件进行polish

N=${SLURM_ARRAY_TASK_ID}         #array值设置为：1-12；这个值的设置是根据sample.csv文件中的样品数(除去第一行的行数)，有多少个样品需要polish就有多少个job，也就设置多少个array
if [ -z $N ]; then               #依次判断1-12参数中是否有空值, 若有空值，则
    N=$1                         
    if [ -z $N ]; then           #依次判断1-12参数中是否有空值, 若有空值，则
	echo "no value for SLURM ARRAY - specify with -a or cmdline"    #若array中有空值，则输出这个
    fi
fi

CPU=$SLURM_CPUS_ON_NODE          #每个节点上的CPU数量赋值给CPU
if [ -z $CPU ]; then             #如果CPU的值为空，给节点分配一个CPU
	CPU=1
fi

mkdir -p $OUTDIR

IFS=,
tail -n +2 $SAMPLES | sed -n ${N}p | while read BASE SPECIES STRAIN NANOPORE ILLUMINA SUBPHYLUM PHYLUM LOCUS RNASEQ   
#脚本‘tail -n +2’的意思为从sample.csv文件的第二行还是输出，因为第一行是表头；‘sed -n ${N}p’只显示第N行内容，读取文件
do
    for type in canu flye                                                 #将 canu flye的值依次赋值给 type；Jason的文件夹Ref_genomes中对所有NRRL8个菌株进行了canu和flye两种方法的组装
    do
	POLISHED=$INDIR/$BASE/$type.polished.fasta                        #将type.polished.fasta文件赋值给POLISHED
	mkdir -p $OUTDIR/$BASE
	PILON=$OUTDIR/$BASE/$type.pilon.fasta                             #将type.pilon.fasta文件赋值给PILON
	if [ ! -f $POLISHED ]; then                                       #如果不存在type.polished.fasta文件
		echo "Medaka polishing did not finish for $STRAIN"        #若就是不存在，就输出以下文字
		continue
	fi
	if [[ ! -f $PILON || $POLISHED -nt $PILON ]]; then                #如果不存在type.pilon.fasta 或者 type.polished.fasta比type.pilon.fasta新 ， 则
	    LEFT=$READDIR/${ILLUMINA}_R1_001.fastq.gz                     # check naming for this；则将LEFT和RIGHT 命名为  {ILLUMINA}_R1_001.fastq.gz 和 {ILLUMINA}_R2_001.fastq.gz
	    RIGHT=$READDIR/${ILLUMINA}_R2_001.fastq.gz
	    AAFTF pilon -l $LEFT -r $RIGHT -it 5 -v -i $POLISHED -o $PILON -c $CPU --memory $MEM     #执行AAFTF pilon软件的各类指令     
	fi
    done
done
