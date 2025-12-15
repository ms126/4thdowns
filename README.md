# NFL 4th Down Decision-Making Model

## Overview
This project builds a machine learning–based decision support system for NFL 4th down play-calling. Using play-by-play data from the 2019–2024 NFL seasons, the model predicts whether a team should go for it, punt, or attempt a field goal based on game context such as field position, score differential, time remaining, and team information. The goal is to provide a data-driven and interpretable framework for evaluating high-leverage in-game decisions.

---

## Data
The dataset consists of NFL play-by-play data from the nflfastR play-by-play CSVs (2019–2024). Each row represents a single play and includes over 300 variables describing game state, team context, and outcomes.

Preprocessing steps:
- Filtered to 4th down plays only
- Removed non-decision plays
- Consolidated actions into three classes:
  - `go` (pass or run)
  - `punt`
  - `field_goal`

---

## Features Used

### Numeric Features
- Yards to go
- Yardline (distance to end zone)
- Quarter
- Score differential
- Half seconds remaining
- Game seconds remaining
- Offensive timeouts remaining
- Defensive timeouts remaining

### Categorical Features
- Home team
- Away team
- Offensive team (posteam)
- Season

Categorical variables are one-hot encoded, and numeric variables are standardized where appropriate.

---

## Models

### Logistic Regression
- Serves as a baseline model
- Highly interpretable
- Helps explain how features influence decision probabilities

### Random Forest
- Captures nonlinear relationships
- Models interactions between game context variables
- Achieves higher predictive performance than logistic regression

---

## Results

- Logistic Regression Accuracy: ~84%
- Random Forest Accuracy: ~90%

The Random Forest model significantly improves performance on aggressive “go for it” decisions while maintaining strong accuracy for punts and field goals.

---

## Use Case
This model is designed to power an interactive interface where users can input game context (field position, score, time, teams) and receive:
- A recommended 4th down decision
- Predicted probabilities for each possible action

Potential applications include coaching analysis, sports analytics research, fan-facing tools, and broadcast insights.

---

## Future Improvements
- Add win probability and expected points features
- Incorporate weather and stadium effects
- Test gradient boosting models (XGBoost, LightGBM)
- Build a Streamlit or web-based interface

---

## Tech Stack
- Python
- pandas
- NumPy
- scikit-learn
- nflfastR play-by-play data

---

## Author
Misha  
Data Science | Sports Analytics | Decision Modeling
