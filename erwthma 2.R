setwd("D:/panepistimio/Διαχείριση Μεγάλων Δεδομένων - Τζαγκαρακης/ergasiatrith/Qduo")

#useful libraries
library(tibble)
library(e1071)
library(stringr)
library(tm)
library(SnowballC)
library(caret)
library(caTools)

imdbdata = read.csv("D:/panepistimio/Διαχείριση Μεγάλων Δεδομένων - Τζαγκαρακης/ergasiatrith/Qduo/IMDBDataset.csv",header=TRUE)

#first rows of observations
head(imdbdata)

#Removing special characters
imdbdata$review= str_replace_all(imdbdata$review, "[^[:alnum:]]", " ")

#Lower case
imdbdata$review = tolower(imdbdata$review)
imdbdata$sentiment = tolower(imdbdata$sentiment)

#stop words
imdbdata$review=removeWords(imdbdata$review,stopwords("english"))

#stemming to see the available languages
getStemLanguages()
wordStem(imdbdata$review, language = "english")

#stemming
stemDocument(imdbdata$review)
imdbdata$review = stemDocument(imdbdata$review)

#question 3
dtm <- DocumentTermMatrix(imdbdata$review)
inspect(dtm)

#question 4
set.seed(1234)
 
#80% of dataset as training set and 20% test set
indexset <- sample(2, nrow(imdbdata), replace = TRUE, prob = c(0.8,0.2))
trainingset  <- imdbdata[indexset==1,]
testset <- imdbdata[indexset==2,]
indexset
 
#question 5
#fitting naive bayes model into training dataset
NaiveBayesModel <- naivebayes (sentiment~ ., data = trainingset)
NaiveBayesModel

#predicy sentiment for the test set
NBMpredict = predict(NaiveBayesModel, newdata= testset)
NBMpredict

#confusion Matrix
testingDataConfusionTable = table(NBMpredict,testset$sentiment)
print(testingDataConfusionTable)

#accuracy
modelAccuracy = sum(diag(testingDataConfusionTable)/sum(testingDataConfusionTable))

sprintf("Model accuracy: %f", modelAccuracy)






 


 