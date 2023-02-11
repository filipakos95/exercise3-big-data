import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.cluster import AgglomerativeClustering
import matplotlib.pyplot as plt
import scipy.cluster.hierarchy as shc
from sklearn.preprocessing import StandardScaler

df = pd.read_csv('europe.csv')

#set country column as index
df = df.set_index('Country')

#remove the country column
X = df.values
country_names = list(df.index)

#do hierarchical clustering on the data with scikit-learn
#scale the data first
ss = StandardScaler()
X_ss = ss.fit_transform(X)

plt.figure(figsize=(10, 7))
plt.title("Dendogram")
dend = shc.dendrogram(shc.linkage(X_ss, method = "complete", metric='euclidean'), labels=country_names)

#use the dendrogram to determine the number of clusters
#use the number of clusters to train the model
cluster = AgglomerativeClustering(n_clusters=3, affinity='euclidean', linkage='ward')
cluster.fit_predict(df)

#add the cluster labels to the dataframe
df['cluster'] = cluster.labels_
df