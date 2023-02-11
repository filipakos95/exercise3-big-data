import pandas as pd
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split 
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import classification_report, ConfusionMatrixDisplay,confusion_matrix 
from sklearn import tree
from sklearn.naive_bayes import GaussianNB

data =  pd.read_csv('agaricus-lepiota.data', sep=",")

# Transform categorical feature(s) to numeric
le = LabelEncoder()
for col in data.columns:
    data[col] = le.fit_transform(data[col])

# Split data into 80% train and 20% validation
X = data.drop('p', axis=1)
y = data['p']

X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=0)

# Build and train model
model = DecisionTreeClassifier()
model.fit(X_train, y_train)

# Apply model to validation data
y_predict = model.predict(X_val)

# Evaluate model
print('Classification metrics: \n', classification_report(y_val, y_predict))

cm = confusion_matrix(y_val, y_predict)
cm_display=ConfusionMatrixDisplay(cm)
cm_display.plot()

tree.plot_tree(model)

#Naive Bayes

gnb = GaussianNB()
gnb.fit(X_train, y_train)

# Apply model to validation data
y_predict = gnb.predict(X_val)

# Evaluate model
print('Classification metrics: \n', classification_report(y_val, y_predict))

cm = confusion_matrix(y_val, y_predict)
cm_display=ConfusionMatrixDisplay(cm)
cm_display.plot()