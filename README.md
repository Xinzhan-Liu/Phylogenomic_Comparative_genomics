# Phylogenomic_Comparative_genomics
此文件夹所有脚本都用来进行comparative genomics分析中使用

第一步：Assembly，使用canu软件对nanopore数据进行组装

第二步：三代数据Polish: 使用medaka软件对组装完的基因组进行三代数据的polish

为了提高并行性，medaka_consensus 程序适用于简单的数据集，但对于运行大型数据集可能不是最佳选择。可以通过独立运行medaka_consensus的组件步骤，实现更高级别的并行性。

该程序执行三项tasks：

1）reads比对到基因组（通过mini_align，它是minimap2上的一个包装）
2）在assembly 区域运行consensus算法（medaka consensus，注意不要下划线！）
3）对第二步产生的结果聚合。创建consensus sequences (medaka stitch)

第三步：二代数据Polish: 使用pilon软件和illumina数据对组装完的基因组进行二代数据的polish
