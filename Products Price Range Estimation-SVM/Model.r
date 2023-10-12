# Import Libraries

library(dplyr)
library(e1071)
library(caret)
library(summarytools)
library(ISLR)
library(corrplot)
library(RColorBrewer)

# Loading Data 

data <- read.csv("train.csv",header=TRUE)

# View Dataframe
View(data)

# View shapes 
dim(data)

# View values of price_range
unique(data$price_range)

# Check for missing values
sum(is.na(data))

# Histogram of target Variable
par(mar=c(5,5,5,5))
plot(hist(data$price_range))


# Correlation Analysis 

Correlation_Matrix<-cor(data)
corrplot(Correlation_Matrix,
         col=brewer.pal(n=21, name="RdYlBu"))

# new dataframe 
data <- data[,c('battery_power','ram','int_memory','n_cores','px_height','px_width','price_range')]
View(data)

# Descriptive Statistics

descr(data, headings = FALSE, # remove headings
      stats = "common" # most common descriptive statistics
)
# train test split
set.seed(1)

#Use 80-20 ratio
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.8,0.2))
train  <- data[sample, ]
test   <- data[!sample, ]

# split train and test to X and Y
x_train <- train[,c('battery_power','ram','int_memory','n_cores','px_height','px_width')]
y_train <- train[,c('price_range')]

x_test<- test[,c('battery_power','ram','int_memory','n_cores','px_height','px_width')]
y_test <- test[,c('price_range')]

# Normalize train data between 0 and 1
# normalizing data

xtrain <- preProcess(x_train, method=c("range"))

x_train_scaled<- predict(xtrain,x_train )


x_test_scaled <- predict(xtrain, x_test)
# summary stats after scaling
descr(x_train_scaled, headings = FALSE, # remove headings
      stats = "common" # most common descriptive statistics
)
descr(x_test_scaled, headings = FALSE, # remove headings
      stats = "common" # most common descriptive statistics
)

# Get features and Target Variable 


x_dat = data.frame(x_train_scaled, y = as.factor(y_train))


x_dat_test <-data.frame(x_test_scaled, y_test)



#SVM Classifier: 1 : 


svm <- svm(formula = y~., data=x_dat, 
           method="C-classification", kernal="radial", 
           gamma=0.1, cost=10)

summary(svm)
svm$SV[0:10]
svm$labels

#Model Evaluation
# compute training accuracy
pred_train <- predict(svm, x_dat)
mean(pred_train == x_dat$y)


# compute test accuracy
pred_test <- predict(svm,x_dat_test)
mean(pred_test == x_dat_test$y_test)

# Confusion matrix

conf_mat <- confusionMatrix(table(x_dat_test$y_test,
                                  predictions = pred_test))

conf_mat


# Grid Search Cross Validation
# Grid 1 :
# Define the grid of parameters to search
grid = expand.grid(sigma = c(0.1, 1, 10),C = c(0.1, 1, 10))

# Perform the grid search with 5-fold cross-validation
svm_grid <- train(x= x_dat[,1:6],y=x_dat[,7], method = "svmRadial",tuneGrid =grid, trControl = trainControl(method = "cv", number = 5))

# Print the results
print(svm_grid)


# Print the best parameters
print(svm_model$bestTune)

#SVM Classifier: First best params : 

# Define the model (SVM with radial kernel)
svm <- svm(formula = y~., data=x_dat, 
           method="C-classification", kernal="radial", 
           gamma=0.1, cost=1)


#Model Evaluation
# compute training accuracy
pred_train <- predict(svm, x_dat)
mean(pred_train == x_dat$y)


# compute test accuracy
pred_test <- predict(svm,x_dat_test)
mean(pred_test == x_dat_test$y_test)

# Confusion matrix

conf_mat <- confusionMatrix(table(x_dat_test$y_test,
                                  predictions = pred_test))

conf_mat











# Grid 2 :
# Define the parameter grid
param_grid <- expand.grid(C = c(0.1, 1,5,0.6,15,20, 2),sigma = c(0.1, 1,7, 12,10))


x_dat[,1:6]
# Perform the grid search with 5-fold cross-validation
svm_grid <- train(x= x_dat[,1:6], y = x_dat$y, method = "svmRadial", tuneGrid = param_grid, trControl = trainControl(method = "cv", number = 5))

print(svm_grid)

#SVM Classifier: Best params 2 : 

# Define the model (SVM with radial kernel)
svm <- svm(formula = y~., data=x_dat, 
           method="C-classification", kernal="radial", 
           gamma=0.1, cost=15)


summary(svm)
svm$SV[0:10]
svm$labels

#Model Evaluation
# compute training accuracy
pred_train <- predict(svm, x_dat)
mean(pred_train == x_dat$y)


# compute test accuracy
pred_test <- predict(svm,x_dat_test)
mean(pred_test == x_dat_test$y_test)

# Confusion matrix
library(caret)

library(ISLR)
conf_mat <- confusionMatrix(table(x_dat_test$y_test,predictions = pred_test))

conf_mat




