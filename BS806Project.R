setwd("/Users/alexmiller/Desktop/BS806")
library(tree)
library(GGally)
library(olsrr)
library(pROC)
data = read.csv("diabetes_binary_health_indicators_BRFSS2015.csv")

data$Stroke = as.factor(data$Stroke)
set.seed(5)
tree1 = tree(Stroke ~ Sex + Age + Smoker + BMI
             + HighChol + PhysActivity + HighBP + HeartDiseaseorAttack 
             + Diabetes_binary, data = final_data, 
             control = tree.control(nobs = nrow(data), mindev = 0.001, minsize = 5))
summary(tree1)
plot(tree1)
text(tree1, pretty = 0, cex = 0.8)

set.seed(2)

# Split cases and controls
cases = data[data$Stroke == 1, ]
controls = data[data$Stroke == 0, ]
n_controls = nrow(cases) * 2
selected_controls = controls[sample(nrow(controls), n_controls), ]
final_data = rbind(cases, selected_controls)


# Logistic regression at 0.01 significance level
glm = glm(Stroke ~., data = final_data, family=binomial)
summary(glm)
glm1 = update(glm,.~.-PhysActivity)
summary(glm1)
glm2 = update(glm1,.~.-HvyAlcoholConsump)
summary(glm2)
glm3 = update(glm2,.~.-AnyHealthcare)
summary(glm3)
glm4 = update(glm3,.~.-Fruits)
summary(glm4)
glm5 = update(glm4,.~.-Sex)
summary(glm5)
glm6 = update(glm5,.~.-Education)
summary(glm6)
glmfinal = glm6
glmfinal

# Tolerance & VIF values
ols_vif_tol(glm)
ols_vif_tol(glmfinal)


## Backwards elimination
set.seed(2)
train = sample(c(1:nrow(final_data)), .7*(nrow(final_data)))
data.train = final_data[train,]
data.test = final_data[-train,]
glmtrain = glm(Stroke ~., data = data.train, family=binomial)
summary(glmtrain)
glmtrain1 = update(glmtrain,.~.-Fruits)
summary(glmtrain1)
glmtrain2 = update(glmtrain1,.~.-Sex)
summary(glmtrain2)
glmtrain3 = update(glmtrain2,.~.-HvyAlcoholConsump)
summary(glmtrain3)
glmtrain4 = update(glmtrain3,.~.-Education)
summary(glmtrain4)
glmtrain5 = update(glmtrain4,.~.-CholCheck)
summary(glmtrain5)
glmtrain6 = update(glmtrain5,.~.-PhysActivity)
summary(glmtrain6)
glmtrain7 = update(glmtrain6,.~.-PhysHlth)
summary(glmtrain7)
glmtrain8 = update(glmtrain7,.~.-Veggies)
summary(glmtrain8)
glmtrain9 = update(glmtrain8,.~.-AnyHealthcare)
summary(glmtrain9)

## ROC Analysis, accuracy, sensitivity, specificity
pred.log = predict(glmtrain9, newdata = data.test, type = "response")
log.roc = roc(data.test$Stroke, pred.log)     
log.roc
table(data.test$Stroke, pred.log>0.5)
plot(log.roc)

