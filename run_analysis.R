library(tidyverse)
#read in common data
activity_labels <- read.table(file="UCI HAR Dataset/activity_labels.txt")
features <- read.table(file="UCI HAR Dataset/features.txt")

#read in "train" data
subject_train <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table(file="UCI HAR Dataset/train/x_train.txt")
y_train <- read.table(file="UCI HAR Dataset/train/y_train.txt")

#read in "test" data
subject_test <- read.table(file="UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table(file="UCI HAR Dataset/test/X_test.txt")
y_test <- read.table(file="UCI HAR Dataset/test/y_test.txt")

#Because we only need to extracts the measurements on the mean and standard deviation for each measurement and 
#data in "Inertial Signals" do not contain "mean" or "std" on their variable names
#Therefore, data in "Inertial Signals" are not used in the following

# body_acc_x_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
# body_acc_y_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
# body_acc_z_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
# body_gyro_x_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
# body_gyro_y_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
# body_gyro_z_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
# total_acc_x_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
# total_acc_y_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
# total_acc_z_train <- read.table(file="UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")

#Aim: Appropriately labels the data set with descriptive variable names
#use features to make the column names of x_train
names (x_train) <-make.names(features$V2, unique = TRUE)

#dim(x_train) has 7352 rows and 561 columns
#add 2 columns of y_train and subject_train to x_train
train_df <- cbind(x_train, y_train, subject_train) 
colnames(train_df)[562:563] <- c("activity", "subject")

#use features to make the column names of x_test
names (x_test) <-make.names(features$V2, unique = TRUE)

#dim(x_test) has 2947 rows and 561 columns
#add 2 more columns y_test and Subject_test 
test_df <- cbind(x_test, y_test, subject_test) 
colnames(test_df)[562:563] <- c("activity", "subject")

#merge the train and test dataframe
df <- full_join(train_df, test_df)
#check with dim(df), there are 10299 rows and 563 columns now

#Extracts only the measurements on the mean and standard deviation for each measurement
df <- df %>% select(contains("mean")|contains("std"), 562:563)

#Uses descriptive activity names to name the activities in the data set
df$activity <- factor(df$activity, levels=activity_labels$V1, labels=activity_labels$V2)
View(df)

#From the above data set (df), creates a second tidy data set with the average of each variable for each activity and each subject
df$subject <- as.factor(df$subject)
df_2 <- df %>% group_by(subject, activity) %>% summarise_all(mean)
View(df_2)

#output data set df_2
write.csv(df_2, file="cleaned_df.csv", row.names = FALSE)
