#load dataset
data <- read.csv("europe.csv", header = TRUE, sep = ",")

#hierarchical clustering
hier <- hclust(dist(data[,2:5]), method = "ward.D2")
plot(hier, hang = -1, main = "Hierarchical Clustering", xlab = "Countries", sub = "Ward's method")

#dendrogram
dend <- as.dendrogram(hier)
dend <- color_branches(dend, k = 3)
plot(dend, main = "Dendrogram", sub = "Ward's method", xlab = "Countries")

