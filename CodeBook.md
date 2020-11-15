# Code Book
This file contains all the descriptions for data, variables and steps performed to get final tidy data

## Data
Source data is taken from UCI machine learning repository, data set is related to human activity recognition using smartphone. Full description can be found [Here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The link to download data set can be found [Here](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip). 


## Steps

 1. **Download Data Set**

		
	 - Data set is downloaded from the above source using `download.file`
	   function.

 2. **Extracting Data from file and assigning to variables**

	 - `x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")`
	 - `y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")`
	 - `subject_train <- read.table("./data/UCI HARDataset/train/subject_train.txt")`
	 - `x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")`
	 - `y_test<- read.table("./data/UCI HAR Dataset/test/Y_test.txt")`
	 - `subject_test<- read.table("./data/UCI HARDataset/test/subject_test.txt")`
	 - `features <- read.table("./data/UCI HAR Dataset/features.txt")`
	 - `activity_labels <- read.table("./data/UCI HAR   Dataset/activity_labels.txt")`

 3. **Assigning column names to each variable just created**

	 - `colnames(x_train) <- features[,2]`
	 - `colnames(y_train) <- "activity"`
	 - `colnames(subject_train) <- "subject"`
	 - `colnames(x_test) <- features[,2]`
	 - `colnames(y_test) <- "activity"`
	 - `colnames(subject_test) <- "subject"`
	 - `colnames(activity_labels) <- c("activityID", "activityType")`

 4. **Merge training data set with testing data set**
		
	   `train_data <- cbind(y_train, subject_train, x_train)`
	  
	  `test_data <- cbind(y_test, subject_test, x_test)`

	`train_test_combined_data <- rbind(train_data, test_data)`

 5. **Extract only the measurement on mean and standard deviation for each measurement**
	- grep only column with name contains mean and std
	`mean_std_column <- grepl("subject|activity|mean|std", colnames(train_test_combined_data))`
	- Create tidy data using the column condition
	  `tidy_data <- train_test_combined_data[, mean_std_column]`
 6. **Change activity code to descriptive activity names**
	 `tidy_data$activity <- activity_labels[tidy_data$activity, 2]`
 7. **Change data column names to descriptive names**
 
	 `names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))`
	 
	`names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))`
	
	`names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))`
	
	`names(tidy_data) <- gsub("^tBody", "TimeBody", names(tidy_data))`
	
	`names(tidy_data) <- gsub("^fBody", "FrequencyBody", names(tidy_data))`
	
	`names(tidy_data) <- gsub("-mean()", "Mean", names(tidy_data))`
	
	`names(tidy_data) <- gsub("-std()", "Accelerometer", names(tidy_data))`
	
	`names(tidy_data) <- gsub("-freq()", "Frequency", names(tidy_data))`
	
	`names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))`
	
	`names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))`
	
 9. **Create another set of data grouped by activity and subject and their average of variables**
 
 	`final_tidy_data <- tidy_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))` 
	

