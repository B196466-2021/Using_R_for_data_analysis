# Using_R_for_data_analysis

Often when working with data we are interested in using R to build data visualisations. We
have data for the processed numerical data for plotting. We have annotation data that will
allow us to build gene and sample names. Each row in the annotation has a gene name and
each row has a row name, as well as other information. We have a list which is a collection
of row names for each element we need to plot. Each row in the processed numerical data
has a unique identifier-the row name. This can be used to uniquely index each row in R. The
elements of the gene list match the row name in the data table and the same gene listed more
than once in the gene list. Not all Genes have a Gene name but all have a unique identifier.
