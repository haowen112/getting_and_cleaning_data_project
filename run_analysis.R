library(dplyr)
# download and import dataset
if(!file.exists("./data")){
  dir.create("./data")
}
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url, destfile = "./data/projectData.zip")
unzip(zipfile = "./data/projectData.zip", exdir = "./data")

# read in all test and train data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# assign column names to training and test data
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity"
colnames(subject_train) <- "subject"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

colnames(activity_labels) <- c("activityID", "activityType")

# 1. Merges the training and the test sets to create one data set.
train_data <- cbind(y_train, subject_train, x_train)
test_data <- cbind(y_test, subject_test, x_test)
train_test_combined_data <- rbind(train_data, test_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# grep only columns with mean and std, and return data with these columns only
mean_std_column <- grepl("subject|activity|mean|std", colnames(train_test_combined_data))
tidy_data <- train_test_combined_data[, mean_std_column]

# 3. Uses descriptive activity names to name the activities in the data set
tidy_data$activity <- activity_labels[tidy_data$activity, 2]

# 4.Appropriately labels the data set with descriptive variable names.
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("^fBody", "FrequencyBody", names(tidy_data))
names(tidy_data) <- gsub("-mean()", "Mean", names(tidy_data))
names(tidy_data) <- gsub("-std()", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("-freq()", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final_tidy_data <- tidy_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))

# write to file
write.table(final_tidy_data, "tidyData.txt",row.names = FALSE)
