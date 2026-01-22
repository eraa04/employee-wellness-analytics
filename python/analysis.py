# 1) Import libraries
import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Figure out project root (one level above /python)
project_root = os.path.dirname(os.path.dirname(__file__))

# Paths for data and visuals
data_raw_dir = os.path.join(project_root, "data_raw")
data_processed_dir = os.path.join(project_root, "data_processed")
visuals_dir = os.path.join(project_root, "visuals")

# Make sure these folders exist (especially visuals & processed)
os.makedirs(data_processed_dir, exist_ok=True)
os.makedirs(visuals_dir, exist_ok=True)

# CSV path
csv_path = os.path.join(data_raw_dir, "employee_wellness_clean.csv")
print("Loading CSV from:", csv_path)

df = pd.read_csv(csv_path)

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix

sns.set(style="whitegrid")

# 2) Load the CSV file
base_path = os.path.dirname(os.path.dirname(__file__))  # project root
csv_path = os.path.join(base_path, "data_raw", "employee_wellness_clean.csv")

df = pd.read_csv(csv_path)

# 3) Take a look at the first 5 rows
print("First 5 rows:")
print(df.head())

# 4) Basic info
print("\nDataFrame info:")
print(df.info())

# 5) Summary statistics
print("\nSummary stats:")
print(df.describe())

# 6) Simple plot: stress level distribution
plt.figure()
sns.histplot(df["stress_level"], kde=True)
plt.title("Stress Level Distribution")
plt.xlabel("Stress Level")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig(os.path.join(visuals_dir, "stress_distribution.png"), dpi=300)
plt.show()

# 7) Burnout risk counts
plt.figure()
sns.countplot(x=df["burnout_risk"])
plt.title("Burnout Risk Counts")
plt.xlabel("Burnout Risk")
plt.ylabel("Number of Employees")
plt.tight_layout()
plt.savefig(os.path.join(visuals_dir, "burnout_counts.png"), dpi=300)
plt.show()

# 8) ----------------- MACHINE LEARNING: Predict Burnout Risk -----------------

print("\n--- Machine Learning: Predicting Burnout Risk ---")

# We will predict the 'burnout_risk' column using some numeric features.

# 8.1 Select features (X) and target (y)
features = ["work_hours", "sleep_hours", "stress_level", "job_satisfaction", "manager_support"]
X = df[features].copy()
y = df["burnout_risk"].copy()

# Drop rows where burnout_risk or features are missing
data = pd.concat([X, y], axis=1).dropna()
X = data[features]
y = data["burnout_risk"]

print("Data used for modeling:", X.shape[0], "rows")

# 8.2 Encode target as numbers (Low=0, Medium=1, High=2)
mapping = {"Low": 0, "Medium": 1, "High": 2}
y_encoded = y.map(mapping)

# 8.3 Split into train and test sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
)

print("Training rows:", X_train.shape[0])
print("Test rows:", X_test.shape[0])

# 8.4 Create and train the model
rf = RandomForestClassifier(
    n_estimators=200,       # number of trees
    random_state=42
)

rf.fit(X_train, y_train)

# 8.5 Evaluate the model
y_pred = rf.predict(X_test)

print("\nAccuracy on test set:", rf.score(X_test, y_test))

print("\nClassification Report (per class):")
print(classification_report(y_test, y_pred, target_names=["Low","Medium","High"]))

# 8.6 Confusion matrix
cm = confusion_matrix(y_test, y_pred)

print("Confusion Matrix:\n", cm)

plt.figure()
sns.heatmap(
    cm,
    annot=True,
    fmt="d",
    cmap="Blues",
    xticklabels=["Low","Medium","High"],
    yticklabels=["Low","Medium","High"]
)
plt.xlabel("Predicted")
plt.ylabel("Actual")
plt.title("Burnout Risk - Confusion Matrix")
plt.tight_layout()
plt.savefig(os.path.join(visuals_dir, "confusion_matrix.png"), dpi=300)
plt.show()

# 8.7 Feature importance (Which columns matter most?)
importances = pd.Series(rf.feature_importances_, index=features).sort_values(ascending=False)

print("\nFeature Importances:")
print(importances)

plt.figure()
importances.plot(kind="bar")
plt.title("Feature Importance for Burnout Prediction")
plt.ylabel("Importance")
plt.tight_layout()
plt.savefig(os.path.join(visuals_dir, "feature_importance.png"), dpi=300)
plt.show()

# 9) Save a processed version for Power BI
processed_csv_path = os.path.join(data_processed_dir, "employee_wellness_processed.csv")
df.to_csv(processed_csv_path, index=False)
print("\nSaved processed dataset to:", processed_csv_path)