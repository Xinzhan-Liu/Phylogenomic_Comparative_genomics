library(gggenomes)

# to inspect the example data shipped with gggenomes
data(package="gggenomes")

# There are 8 datasets in package 'gggenomes'
# to inspect each dataset using 'data.frame()'，查看每一个数据集
data.frame(emale_genes)

#load the seqs file
s0 <- read_table("seqs.txt")

#load the genes file
g0 <- read.table("3_test.csv", sep = ",", header = TRUE)

#add two tracks including seqs and genes
gggenomes(g0,s0)+geom_seq()+geom_gene()+geom_gene_tag(aes(label=name))
