# Library including the aprιori algorithm
#install.packages("arules")
library (arules)
setwd ("D:/panepistimio/Διαχείριση Μεγάλων Δεδομένων - Τζαγκαρακης/ergasiatrith")

#data
FertilityData <- read.csv('fertility_Diagnosis.txt', header=F)

#erwthma 1
#Remove from the dataset the 2nd (Age) and the 9th (Number of hours spent sitting per day) column
FertilityDataN <- FertilityData[,-c(2,9)]

# Add headers to data. Makes working with the dataset easier and helps interpreting the rules better
colnames(FertilityDataN) <- c("Season","ChildDiseases","AccidentorSerioustrauma","SurgicalIntervention","HighFevers",
                             "FrequencyofAlcoholConsumption","SmokingHabit","Diagnosis")

# Convert all variables to factors
FertilityDataN[] <- lapply(FertilityDataN, as.factor)
str(FertilityDataN)

# Execute initially the apriori algorithm for finding association rules WITHOUT any threshold 
# for support or confidence. This means that no minsup and minconf threshold is provided and 
# hence that ALL POSSIBLE rules will be generated - WARNING: number of rules will be HUGE!
rules1 <- apriori(FertilityDataN)

# Now, variable rules contains ALL POSSIBLE association the rules calculated. Let's see them
inspect(rules1)


# erwthma 2

#minimum threshold for support, confidence and some other parameters. We execute apriori with the following thresholds : minimum support
rules2 <- apriori(FertilityDataN, parameter = list(supp=0.02, conf=1), appearance = list(rhs="Diagnosis=O", default="lhs"))

# Inspect rules
inspect(rules2)

# erwthma 3
sortedRulesByLift <- sort (rules2, by="lift", decreasing=TRUE)

# sorted rules 
inspect(sortedRulesByLift)

# rules that are not redundant
rules3 <- sortedRulesByLift[!is.redundant(sortedRulesByLift)]

# Inspect rules
inspect(rules3)

# install.packages("arulesViz")
library(arulesViz)
plot(rules3)