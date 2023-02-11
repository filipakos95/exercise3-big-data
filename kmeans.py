import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from kmodes.kmodes import KModes
from plotnine import *
import plotnine


movies = pd.read_csv('movies.csv')
ratings = pd.read_csv('ratings.csv')

#drop the row with no genres listed
movies = movies[movies['(no genres listed)'] == 0]

#remove title column for training
train_df = movies.drop('title', axis=1)

# Use the theme of ggplot
plt.style.use('ggplot')

# Choosing optimal K
print('Choosing optimal K...')

cost = []
for cluster in range(1, 20):
    try:
        kmodes = KModes(n_jobs = -1, n_clusters = cluster, init = 'Huang', random_state = 0)
        kmodes.fit_predict(train_df)
        cost.append(kmodes.cost_)
    except:
        break
# Converting the results into a dataframe and plotting them
df_cost = pd.DataFrame({'Cluster': range(1, 20), 'Cost': cost})
# Data viz
plotnine.options.figure_size = (8, 4.8)
(
    ggplot(data = df_cost)+
    geom_line(aes(x = 'Cluster',
                  y = 'Cost'))+
    geom_point(aes(x = 'Cluster',
                   y = 'Cost'))+
    geom_label(aes(x = 'Cluster',
                   y = 'Cost',
                   label = 'Cluster'),
               size = 10,
               nudge_y = 1000) +
    labs(title = 'Optimal number of cluster with Elbow Method')+
    xlab('Number of Clusters k')+
    ylab('Cost')+
    theme_minimal()
)

#3. use kmodes with 4 clusters
print('Training K-Modes model...')
km = KModes(n_clusters=4, init='Huang', n_init=4, verbose=1)
clusters = km.fit_predict(train_df)
movies['clusterid'] = clusters

print('Done training K-Modes model')

#4. merge the movies and ratings dataframes on movieId
movies_ratings = pd.merge(movies, ratings, on='movieId')
#keep only the userId,movieid, clusterid, and rating columns
movies_ratings = movies_ratings[['userId', 'movieId', 'clusterid', 'rating']]

#for each movieid, get the average rating
avg_ratings = movies_ratings.groupby('movieId')['rating'].mean().reset_index()

#5. get user input for userId
user_id = int(input('Enter a user id: '))

#for userid get the movies they rated
user_ratings = movies_ratings[movies_ratings['userId'] == user_id]

grouped = user_ratings.groupby('clusterid')['rating'].mean().reset_index()

grouped = grouped[grouped['rating'] > 3.5]


#TODO
#if in grouped no ratings are above 3.5, then print no recommendations
if grouped.empty:
    print('Sorry, no recommendations for you')
else:
    #get the clusterids for the movies that the user rated above 3.5
    clusterids = grouped['clusterid'].tolist()
    #get the movies that the user rated above 3.5
    movies_for_user = movies[movies['clusterid'].isin(clusterids)]
    #get the movies that the user has not rated
    movies_not_rated = movies_for_user[~movies_for_user['movieId'].isin(user_ratings['movieId'].tolist())]
    #get the average ratings for the movies that the user has not rated
    movies_not_rated = pd.merge(movies_not_rated, avg_ratings, on='movieId')
    #sort the movies by average rating
    movies_not_rated = movies_not_rated.sort_values(by='rating', ascending=False)
    #get the top 2 movies
    top_movies = movies_not_rated.head(2)
    #print the top 2 movies
    print(top_movies['title'])


