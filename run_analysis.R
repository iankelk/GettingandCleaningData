library(dplyr)

## Download the file and save it in the /data folder
if(!file.exists("./data")) {
  dir.create("./data")
}
## Download the file from the URL, unzip it, and save the data set
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzip the archive
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Save the data in the UCI HAR Dataset directory
path_data <- file.path("./data" , "UCI HAR Dataset")

## Read all the data from the files. 
features <- read.table(file.path(path_data, "features.txt"), col.names = c("n","functions"))
activities <- read.table(file.path(path_data, "activity_labels.txt"), col.names = c("code", "activity"))
subject_test <- read.table(file.path(path_data, "test" , "subject_test.txt"), col.names = "subject")
subject_train <- read.table(file.path(path_data, "train", "subject_train.txt"), col.names = "subject")
x_test <- read.table(file.path(path_data, "test" , "X_test.txt" ))
y_test <- read.table(file.path(path_data, "test" , "Y_test.txt" ), col.names = "code")
x_train <- read.table(file.path(path_data, "train", "X_train.txt"))
y_train <- read.table(file.path(path_data, "train", "Y_train.txt"), col.names = "code")
## Set the column names of x_test and x_train using colnames() as read.table replaced parenthesis with periods.
colnames(x_test) <- features$functions
colnames(x_train) <- features$functions

## Extracts only the measurements on the mean and standard deviation for each measurement. 
all_data <- cbind(rbind(subject_train, subject_test),
                  rbind(y_train, y_test),
                  rbind(x_train, x_test)) %>% 
  dplyr::select(subject, code, contains("mean()"), contains("std()"))

## Uses descriptive activity names to name the activities in the data set.
all_data$code <- activities[all_data$code, 2]

## Appropriately labels the data set with descriptive variable names.  
names(all_data)[2] = "activity"
names(all_data)<-gsub("^t", "Time", names(all_data))
names(all_data)<-gsub("^f", "Frequency", names(all_data))
names(all_data)<-gsub("Acc", "Accelerometer", names(all_data))
names(all_data)<-gsub("angle", "Angle", names(all_data))
names(all_data)<-gsub("BodyBody", "Body", names(all_data))
names(all_data)<-gsub("gravity", "Gravity", names(all_data))
names(all_data)<-gsub("Gyro", "Gyroscope", names(all_data))
names(all_data)<-gsub("Mag", "Magnitude", names(all_data))
names(all_data)<-gsub("tBody", "TimeBody", names(all_data))

## Creates a second, independent tidy data set with the average of each variable for 
## each activity and each subject.
tidy_data <- all_data %>%
  dplyr::group_by(subject, activity) %>%
  dplyr::summarise(across(everything(), mean))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)