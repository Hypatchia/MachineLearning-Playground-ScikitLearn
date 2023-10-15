# App-Enrollment-Prediction
#### Predict App Enrollement based on User Data : Costumer Behavior

* The objective is to predict whether a costumer will enroll to the app or not based on their user data
* Use Case :
  * We want to target the users who are less likely to enroll to make them enroll through campaigns .
* Understanding our ML Pipeline
    * Input : User Data from app_data database  
    * output : Enrollment values ( 0 or 1)
* Framing the Problem :
    * The problem here is a typical supervised learning task since we have Labeled Training examples
* Designing the System :
    * The Value of the output is 0 or 1 So the goal is to predict a binary value
    * This is a regression task since we are asked to PREDICT A VALUE
    * It is a Univariate Regression problem since we Have one single dependent value to predict which is "Enrolled"
* Selecting a performance measure
    * We are going to test the follwing : ROC Curve (AUC), classification Report and Confusion Matrix.
