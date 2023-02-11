install.packages("caret", dependencies = TRUE)
install.packages("rpart.plot")

# Import our required libraries
library(rpart)
library(caret)
library(caTools)
library(rpart.plot)

mushroom_data <- read.csv("/cloud/project/agaricus-lepiota.data")
#convert to data frame
mushroom_data <- as.data.frame(mushroom_data)

#initialize random sequenz 
set.seed(123)
sample = sample.split(mushroom_data$p, SplitRatio = .80)
train_data = subset(mushroom_data, sample == TRUE)
test_data = subset(mushroom_data, sample == FALSE)

tree <- rpart(p ~., data = train_data)

#predictions
tree.survived.predicted <- predict(tree, test_data, type = 'class')

#confusion matrix
confusionMatrix(table(tree.survived.predicted, test_data$p))

prp(tree)
