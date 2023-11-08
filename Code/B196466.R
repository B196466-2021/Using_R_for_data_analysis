####################################
#     RDS Class Assignment         #
#     Author: B196466              #
#     Date:28/11/2021              #
####################################

#Guideline

#Often when working with data we are interested in using R to build data visualisations.
#We have data for the processed numerical data for plotting.
#We have annotation data that will allow us to build gene and sample names.
#Each row in the annotation has a gene name and each row has a row name, as well as other information.
#We have a list which is a collection of row names for each element we need to plot.
#Each row in the processed numerical data has a unique identifier-the row name. This can be used to uniquely index each row in R.
#The elements of the gene list match the row name in the data table and the same gene listed more than once in the gene list.
#Not all Genes have a Gene name but all have a unique identifier.


###############################
#First part: Accessing the Data
###############################
#Firstly, we need to create a directory and change our working directory there.
#Then copy the file which we need to our working directory and unzip it.
#In terminal, For example, like the following:
#mkdir assignment 
#cd  assignment
#cp -R /shared_files/RDS_assignment/s2170612_files.zip .
#unzip s2170612_files.zip
#So now we have the information about the files that we need to make the plot. We can then bring the data into R.
#And in R, we need to input "setwd("~/assignment")" to set it as our working directory.

#Note: We can use ls() and dir() to check the files in the workspace.
dir()


#####################################
#Second part: Loading Data into R.   
#####################################
#Note: If you put the files in another location, please adjust the paths
#Note: We are now using relative paths so if the data folder is moved all the code will still work!
#Note: We can use head() and tail() command for checking tables.
#Note: We can use class() and typeof() to check the types of the objects created.

#The input data table which called “data_all.csv” is numerical data with row 1 containing sample names and column 1 containing gene names.
data<-read.csv("data_all.csv",header = T,row.names = 1)
#check the file result
head(data)
#check the types of the objects created
class(data)

#There is a table “gene_annotation.csv” containing gene annotation.
gene<-read.csv("gene_annotation.csv")
#check the file result
head(gene)
#check the types of the objects created
class(gene)

#There is a table “sample_annotation.csv” containing sample annotation.
sample<-read.csv("sample_annotation.csv")
#check the file result
head(sample)
#check the types of the objects created
class(sample)

#The last file provides a list of genes to use for plotting which called “genelist_s2170612.txt”.
genelist<-read.csv("genelist_s2170612.txt")
#check the file result
head(genelist)
#check the types of the objects created
class(genelist)


######################################
#Third part:De-duplicate genelist name
######################################
#Select the required data for the plot and only those genes on the “genelist_s2170612.txt” need to be plotted. 
#Each gene should only appear once on the final plot for some of the genelist ID are not unique.

#we can remove the ‘duplicate’ elements using the command duplicated()

#show duplicated genelist and set as "index"
index<-duplicated(genelist$"x")
#check the contents of genelist$"x"
print(genelist$"x")
#check the types of the objects created
class(genelist$"x")
#It returns a logical vector TRUE, FALSE, TRUE that indicates which elements are unique
#Then just remove the FALSE elements by indexing with the logical vector

#use to "index" to remove duplicated genelist name in the file “genelist_s2170612.txt” and set as "new_genelist"
#Notice here we use the “!” operator to reverse the logical vector
new_genelist<-genelist[!index,]
#check the contents of index
print(index)
#check the types of the objects created
class(index)
#check the contents of !index
print(!index)
#check the types of the objects created
class(!index)
#Take care otherwise we keep the duplicates and discard the unique IDs!
#check the contents of new_genelist 
print(new_genelist)
#check the types of the objects created
class(new_genelist)

#former genelist number 
nrow(genelist)
#new genelist number
length(new_genelist)

#Now we can see that there is one gene duplicated

#Use new_genelist as an index to pull out only those elements needed for printing and set as "new_data"
new_data<-data[new_genelist,]
#check the contents of new_data
head(new_data)
#check the types of the objects created
class(new_data)


######################################
#Fourth part: plot annotate
######################################
#Note: We can also use the rownames() and colnames() to check its rownames and colnames.

#annotate each gene row with the type of gene (XA, XB or XC)  
#set the rownames
rownames(gene)<- gene$LongName
#check the rownames of gene
head(rownames(gene))

#change "Type" as string style
row_annotation=as.data.frame(gene['Type'])
#check row_annotation 
head(row_annotation)
#check the types of the objects created
class(row_annotation)

#annotate each sample with the treatment group 
#set the rownames
rownames(sample)<- sample$SampleName
#Check the rownames of sample
head(rownames(sample))

#change "TreatmentGroup" as string style
col_annotation=as.data.frame(sample['TreatmentGroup'])
#check col_annotation 
head(col_annotation)
#check the types of the objects created
class(col_annotation)

####################################
#Fifth part:Rename the gene names
####################################
#rename the gene names with the “LongName” from the gene annotation table

#Use new_genelist as an index to pull out only those elements needed for printing and set as "new_gene"
new_gene<-gene[new_genelist,]
#check new gene
head(new_gene)
#check the types of the objects created
class(new_gene)

#set the rownames
rownames(new_data)=new_gene$LongName
#Check the rownames of data
head(rownames(new_data))


###############################
#Sixth part:Create two heatmaps
###############################
#quote "pheatmap" function
library(pheatmap)

#pheatmap which both the genes and the samples are clustered
#`annotation_col` means column annotation, `annotation_row` means row annotation,`fontsize_row` means row size,`fontsize_col`means column size, `scale='row'`means parameters to normalise rows and `main`means title.
pheatmap(new_data,annotation_col=col_annotation,annotation_row=row_annotation,fontsize_row = 6,fontsize_col=12,scale='row',main='gene and sample clustered',cluster_cols=TRUE)

#pheatmap which only the genes are clustered
pheatmap(new_data,annotation_col=col_annotation,annotation_row=row_annotation,fontsize_row = 6,fontsize_col=12,scale='row',main='gene clustered',cluster_cols=FALSE)

#Visual and aesthetic presentation of expression levels of multiple genes in multiple samples by using colour. Use colour gradients and similarity to reflect similarities and differences in the data.
#Cluster analysis essentially uses the degree of difference or similarity between two groups of values as a basis for clustering multiple groups of values in a hierarchical manner in order to ultimately obtain the clustering distances between samples.

#We can see that "Type" and "TreatmentGroup" are very useful annotations. 
#1.Different "Treatment" change the expression level of different gene samples which increases some genes, decreases others. The Treatment 4 has the maximum impact and the treatment 1,2,3 have the similar result 
#2.Some genes with similar function cluster together for example(1440739_at and 1436799_at) 
#3.In the treatment 1,2,3, the expression level of Type XB gene is higher than that of Type XA and XC gene. 4. In the treatment 
#4, the expression level of Type XA gene is higher than that of Type XB and XC gene.


