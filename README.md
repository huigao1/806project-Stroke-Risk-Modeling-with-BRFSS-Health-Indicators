# Stroke Risk Modeling with BRFSS Health Indicators

A statistical and machine learning project that compares interpretable and nonlinear classification models for identifying stroke risk from demographic, behavioral, and chronic-health indicators.

## Project Overview

Stroke is a major public-health concern whose risk is shaped by chronic conditions, health behaviors, age, and access to care. Identifying high-risk individuals can support earlier intervention, but stroke datasets are often highly imbalanced: the number of recorded stroke cases is much smaller than the number of non-stroke cases.

This project uses the 2015 Behavioral Risk Factor Surveillance System health indicators dataset to compare Logistic Regression, Classification Tree, Random Forest, and XGBoost models. The analysis emphasizes AUC rather than accuracy alone and combines interpretable statistical modeling with higher-performing machine learning.

## Objectives

- Identify demographic, behavioral, and clinical indicators associated with stroke
- Engineer interaction features that capture combined health risks
- Compare interpretable and nonlinear classification methods
- Address class imbalance during model development
- Evaluate model discrimination with ROC curves and AUC
- Examine performance across gender and age subgroups
- Recommend a modeling approach that balances prediction and explainability

## Dataset

- **Source:** 2015 BRFSS health indicators dataset
- **Records:** 253,680 respondents
- **Features:** 21 predictors and one binary stroke outcome
- **Target:** `Stroke` (`0 = no stroke`, `1 = stroke`)

The dataset includes:

| Category | Variables |
| --- | --- |
| Chronic conditions | Diabetes, high blood pressure, high cholesterol, heart disease or heart attack |
| Health behaviors | Smoking, physical activity, fruit and vegetable intake, heavy alcohol consumption |
| Health status | BMI, general health, mental-health days, physical-health days, difficulty walking |
| Healthcare access | Cholesterol screening, healthcare coverage, inability to see a doctor because of cost |
| Demographics | Sex, age, education, and income |

## Data Preparation and Feature Engineering

- Converted the stroke outcome into a categorical target
- Standardized BMI as a z-score
- Created `Produce`, indicating fruit or vegetable consumption
- Grouped age into 13 ordered age bands
- Created four interaction terms:
  - `BP_Smoke`: high blood pressure × smoking
  - `Diab_Activity`: diabetes × physical activity
  - `Chol_Age`: high cholesterol × age group
  - `Sex_Activity`: sex × physical activity
- Sampled controls relative to stroke cases during development to reduce class imbalance
- Used a 70/30 training and test split

## Models

### Logistic Regression

A multivariable logistic model was refined through backward elimination. Variance Inflation Factor and tolerance diagnostics were used to assess multicollinearity. The model provides interpretable coefficients and a strong baseline for understanding risk relationships.

### Classification Tree

A decision tree was fitted to capture nonlinear splits and interactions. Although easy to interpret, the final tree showed limited discriminatory performance on the test data.

### Random Forest

The Random Forest model used class weighting to improve sensitivity to the minority stroke class. It produced more balanced classification behavior but lower overall AUC than Logistic Regression and XGBoost.

### XGBoost

The gradient-boosted model used a binary logistic objective with a maximum depth of 6, learning rate of 0.1, and 150 boosting rounds. It achieved the strongest AUC among the evaluated models.

## Model Performance

| Model | Test AUC | Test accuracy |
| --- | ---: | ---: |
| Logistic Regression | 0.805 | 95.9% |
| Classification Tree | 0.500 | 95.9% |
| Random Forest | 0.691 | 76.9% |
| **XGBoost** | **0.825** | **95.9%** |

The high accuracy of multiple models is partly driven by the dominant non-stroke class. AUC provides a more informative measure of how well each model separates stroke from non-stroke cases. XGBoost delivered the best discrimination, while Logistic Regression remained a competitive and interpretable baseline.

## Key Findings

### Cholesterol and age interaction

The interaction between high cholesterol and age group (`Chol_Age`) was the dominant signal in the Logistic Regression analysis. Older respondents with high cholesterol showed the strongest association with reported stroke.

### Chronic conditions and physical activity

XGBoost feature importance also emphasized chronic health conditions, age-related effects, and physical activity. These findings support the importance of evaluating combined risk profiles rather than isolated variables.

### Subgroup performance

- XGBoost AUC was approximately **0.78 for males** and **0.83 for females**.
- Predictive performance was strongest among respondents aged approximately **60-79**.
- The performance differences suggest that subgroup-specific calibration or modeling may improve reliability.

## Recommended Modeling Strategy

Use a hybrid approach:

- **XGBoost** for stronger predictive discrimination and nonlinear risk interactions
- **Logistic Regression** for coefficient-based interpretation, policy communication, and risk-factor explanation

For a real screening application, the decision threshold should be selected according to the cost of false negatives and false positives rather than defaulting to 0.5. Sensitivity, specificity, calibration, and subgroup fairness should be evaluated before deployment.

## Technology

`R` `Logistic Regression` `Classification Trees` `Random Forest` `XGBoost` `pROC` `olsrr` `GGally`

## Repository Structure

```text
├── BS806Project.R
├── diabetes_binary_health_indicators_BRFSS2015.csv
├── Stroke_Risk_Modeling_Report_20251210.docx
└── README.md
```

## Running the Analysis

1. Place the R script and CSV file in the same directory.
2. Replace the local `setwd()` path in `BS806Project.R` with your project directory, or open the project through an RStudio project file.
3. Install the required R packages.
4. Run the script from a clean R session.

```r
install.packages(c("tree", "GGally", "olsrr", "pROC"))
```

Additional Random Forest and XGBoost packages may be required for the complete modeling workflow documented in the report.

## Limitations

- BRFSS responses are self-reported and may contain recall or reporting bias.
- The data is cross-sectional, so associations should not be interpreted as causal effects.
- Stroke cases are rare, making accuracy potentially misleading.
- Resampling controls changes the class distribution and requires probability recalibration for population-level use.
- The available R script contains the Logistic Regression and tree workflow but does not include every Random Forest and XGBoost step summarized in the report.
- Test-set performance should be confirmed with repeated cross-validation and external validation.
- Clinical deployment would require prospective validation, calibration analysis, fairness testing, and professional medical oversight.

## Future Work

- Use stratified cross-validation and repeated resampling
- Compare class weighting, undersampling, oversampling, and SMOTE
- Report sensitivity, specificity, precision-recall AUC, and calibration metrics
- Tune XGBoost and Random Forest through cross-validated hyperparameter search
- Add SHAP values or partial-dependence plots for individual and global explanations
- Evaluate model fairness across age, sex, income, education, and healthcare-access groups
- Validate the final model on newer BRFSS data


## Project Context

This project was completed for **BS806** in December 2025. It demonstrates statistical feature engineering, imbalanced classification, ROC analysis, subgroup evaluation, and the tradeoff between model interpretability and predictive performance.
