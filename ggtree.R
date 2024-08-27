> library(ape)
> library(ggtree)
> setwd("/rhome/xinzhanl/R/ggtree/")
> getwd()
[1] "/rhome/xinzhanl/R/ggtree"

> tree <- read.tree("iqtree.treefile")
> rooted_tree <- root(tree, outgroup = c("Sporobolomyces_roseus_SR19","Sporidiobolus_pararoseus_NGR"), resolve.root = TRUE)
> character <- read_table("assembly_and_annotation_statistics.txt")

> p <- ggtree(rooted_tree) %<+% character + geom_tiplab(size=3)
> p

> p1 <- ggtree(rooted_tree) %<+% character + geom_tiplab(size=6)+geom_tippoint(aes(color=Sex,size=10))
> p1

> genome_size <- read_table("genome_size.txt")
> p2 <- p1 + geom_facet(panel = "Genome_size", data=genome_size,geom = geom_col,aes(x=size),orientation='y',width=.6)
> p2
