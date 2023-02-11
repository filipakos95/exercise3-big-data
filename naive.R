install.packages("naivebayes") 


library(naivebayes)
library(dplyr)
library(ggplot2)

mushroom_data <- read.csv("/cloud/project/agaricus-lepiota.data")
#convert to data frame
mushroom_data <- as.data.frame(mushroom_data)

#initialize random sequenz 
set.seed(123)
sample = sample.split(mushroom_data$p, SplitRatio = .80)
train_data = subset(mushroom_data, sample == TRUE)
test_data = subset(mushroom_data, sample == FALSE)

model <- naive_bayes(p ~ ., data = train_data, usekernel = T) 

tree.survived.predicted <- predict(model, test_data, type = 'class')

confusionMatrix(table(tree.survived.predicted, test_data$p))
