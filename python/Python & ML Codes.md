#### **Python Phase**



**To import libraries \& create tables and graph**

\# 1) Import libraries

import pandas as pd

import matplotlib.pyplot as plt

import seaborn as sns



sns.set(style="whitegrid")



\# 2) Load the CSV file

df = pd.read\_csv("employee\_wellness\_clean.csv")



\# 3) Take a look at the first 5 rows

print("First 5 rows:")

print(df.head())



\# 4) Basic info

print("\\nDataFrame info:")

print(df.info())



\# 5) Summary statistics

print("\\nSummary stats:")

print(df.describe())



\# 6) Simple plot: stress level distribution

plt.figure()

sns.histplot(df\["stress\_level"], kde=True)

plt.title("Stress Level Distribution")

plt.xlabel("Stress Level")

plt.ylabel("Count")

plt.show()



\# 7) Burnout risk counts

plt.figure()

sns.countplot(x=df\["burnout\_risk"])

plt.title("Burnout Risk Counts")

plt.xlabel("Burnout Risk")

plt.ylabel("Number of Employees")

plt.show()



#### **ML Phase**

**7.1 Changed libraries to these**

import pandas as pd

import matplotlib.pyplot as plt

import seaborn as sns



from sklearn.model\_selection import train\_test\_split

from sklearn.ensemble import RandomForestClassifier

from sklearn.metrics import classification\_report, confusion\_matrix



sns.set(style="whitegrid")



**7.2 Code for modeling after # 7 of above code**

\# 8) ----------------- MACHINE LEARNING: Predict Burnout Risk -----------------



print("\\n--- Machine Learning: Predicting Burnout Risk ---")



\# We will predict the 'burnout\_risk' column using some numeric features.



\# 8.1 Select features (X) and target (y)

features = \["work\_hours", "sleep\_hours", "stress\_level", "job\_satisfaction", "manager\_support"]

X = df\[features].copy()

y = df\["burnout\_risk"].copy()



\# Drop rows where burnout\_risk or features are missing

data = pd.concat(\[X, y], axis=1).dropna()

X = data\[features]

y = data\["burnout\_risk"]



print("Data used for modeling:", X.shape\[0], "rows")



\# 8.2 Encode target as numbers (Low=0, Medium=1, High=2)

mapping = {"Low": 0, "Medium": 1, "High": 2}

y\_encoded = y.map(mapping)



\# 8.3 Split into train and test sets

X\_train, X\_test, y\_train, y\_test = train\_test\_split(

    X, y\_encoded, test\_size=0.2, random\_state=42, stratify=y\_encoded

)



print("Training rows:", X\_train.shape\[0])

print("Test rows:", X\_test.shape\[0])



\# 8.4 Create and train the model

rf = RandomForestClassifier(

    n\_estimators=200,       # number of trees

    random\_state=42

)



rf.fit(X\_train, y\_train)



\# 8.5 Evaluate the model

y\_pred = rf.predict(X\_test)



print("\\nAccuracy on test set:", rf.score(X\_test, y\_test))



print("\\nClassification Report (per class):")

print(classification\_report(y\_test, y\_pred, target\_names=\["Low","Medium","High"]))



\# 8.6 Confusion matrix

cm = confusion\_matrix(y\_test, y\_pred)



print("Confusion Matrix:\\n", cm)



plt.figure()

sns.heatmap(

    cm,

    annot=True,

    fmt="d",

    cmap="Blues",

    xticklabels=\["Low","Medium","High"],

    yticklabels=\["Low","Medium","High"]

)

plt.xlabel("Predicted")

plt.ylabel("Actual")

plt.title("Burnout Risk - Confusion Matrix")

plt.show()



\# 8.7 Feature importance (Which columns matter most?)

importances = pd.Series(rf.feature\_importances\_, index=features).sort\_values(ascending=False)



print("\\nFeature Importances:")

print(importances)



plt.figure()

importances.plot(kind="bar")

plt.title("Feature Importance for Burnout Prediction")

plt.ylabel("Importance")

plt.show()



**7.4 Save a clean file for Power BI - add code after #8 of above**

\# 9) Save a processed version for Power BI

df.to\_csv("employee\_wellness\_processed.csv", index=False)

print("\\nSaved processed dataset to employee\_wellness\_processed.csv")

