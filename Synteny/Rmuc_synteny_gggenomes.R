> setwd("/rhome/xinzhanl/R/synteny/5_synteny_subregions_add_RHA")
> getwd()
[1] "/rhome/xinzhanl/R/synteny/5_synteny_subregions_add_RHA"

> library(gggenomes)

#step1：Read in the genomes
> Rmuc_seqs <- tibble::tibble(bin_id = c("R_mucilaginosa_NRRL_Y-2510","R_mucilaginosa_JGTA-S1","R_mucilaginosa_JGTA-S1","R_mucilaginosa_JY1105","R_mucilaginosa_JY1105"),seq_id = c("scaffold_12","PEFX01000011","PEFX01000014","JANBVD010000011","JANBVD010000016"),length = c ("150774","105489","44364","91059","79242"))
> Rmuc_seqs

#Ensure that the “length” is numeric
> Rmuc_seqs <- Rmuc_seqs %>% mutate(length = as.numeric(length))
> p <- gggenomes(seqs = Rmuc_seqs)
> p + geom_seq() + geom_seq_label()

#step 2： Annotate genes
> Rmuc_genes_filtered <- read.table("Rmuc_total_subregion_filtered.txt",header = TRUE)
> Rmuc_genes_filtered

#> p1 <- gggenomes(seqs = Rmuc_seqs,genes = Rmuc_genes_filtered)
#> p1+geom_seq()+geom_seq_label()+geom_gene(position = "strand")+geom_bin_label()

#> p1 <- gggenomes(seqs = Rmuc_seqs,genes = Rmuc_genes_filtered)+geom_seq()+geom_seq_label()+geom_gene()+geom_bin_label()
#> p1

> p1 <- gggenomes(seqs = Rmuc_seqs,genes = Rmuc_genes_filtered)+geom_seq()+geom_seq_label()+geom_gene()+geom_bin_label()+geom_gene_tag(aes(label=Name), vjust = 0.5,hjust = -0.2, angle = 80)

#step 3：Compare genome synteny`
minimap2 mapping to produce the link file：
xinzhanl@skylark:~/R/synteny/2_synteny_subregions$ minimap2 -X -N 50 -p 0.1 -c Rmuc_total_subregion.fna Rmuc_total_subregion.fna > Rmuc_total_subregion.paf

> Rmuc_links <- read_paf("Rmuc_total_subregion.paf")
> p2 <- gggenomes(seqs = Rmuc_seqs,genes =Rmuc_genes_filtered,links = Rmuc_links)+geom_seq()+geom_seq_label()+geom_gene()+geom_bin_label()+geom_link(offset = 0.03)+geom_gene_tag(aes(label=Name), vjust = 0.5,hjust = -0.2, angle = 80)
> p2

#step 4：flip sequences
> p3 <- p2 %>% flip_seqs("scaffold_12") 
> p3
> p4 <- p3 %>% flip_seqs("JANBVD010000016") 
> p4
