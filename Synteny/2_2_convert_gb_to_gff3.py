#虽然gggenomes可以使用genbank文件，但是由于示例中使用的是gff文件，因此将genbank文件转换为gff文件
#在使用BCBio前，module load biopython

#!/usr/bin/env python
from BCBio import GFF
from Bio import SeqIO

in_file = "/bigdata/stajichlab/xinzhanl/Comparative_genomes/final_genomes_gbk/HD_subrange_gbk/R_araucariae_Y17376_scaffold_6_sub.gbk"
out_file = "/bigdata/stajichlab/xinzhanl/Comparative_genomes/final_genomes_gbk/HD_subrange_gbk/R_araucariae_Y17376_scaffold_6_sub.gff"
in_handle = open(in_file)
out_handle = open(out_file, "w")

GFF.write(SeqIO.parse(in_handle, "genbank"), out_handle)

in_handle.close()
out_handle.close()
