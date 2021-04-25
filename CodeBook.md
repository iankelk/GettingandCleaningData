---
title: "CodeBook"
output: 
  html_document: 
    keep_md: yes
---



### Load dplyr Library

```r
library(dplyr)
```

### Initial Data Collection
* Download and extract the data set into the folder `UCI HAR Dataset`.

```r
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
```

### Read files to create data frames.


```r
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
```

### Extract only the mean and standard deviation for each measurement.

Combining the the both the training and testing data for subject, x, and y, get only the rows containing the mean and standard deviations indicated by "mean" and "std".

```r
all_data <- cbind(rbind(subject_train, subject_test),
                  rbind(y_train, y_test),
                  rbind(x_train, x_test)) %>% 
  dplyr::select(subject, code, contains("mean()"), contains("std()"))
```

### Use descriptive activity names to name the activities in the data set.

Using the descriptive names for the activities, name the activities in the data set.
* code column in `all_data` renamed into `activities`

```r
all_data$code <- activities[all_data$code, 2]
```

### Appropriately labels the data set with descriptive variable names.

* If a column begins with "t" change it to begin with "Time".
* If a column begins with "f" change it to begin with "Frequency".
* If a column contains `Acc` replace it with `Accelerometer`
* If a column contains `Gyro` replace it with `Gyroscope`
* If a column contains `BodyBody` replace it with `Body`
* If a column contains `Mag` replace it with `Magnitude`

Leave the indicators of `-mean()` and `std()` as well as their variable names such as `-mean()-X` and -`std()-X` to clearly show what metric is being included and what variable it is calculating.


```r
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
```

### Create a second tidy data set with the average of each variable for each activity and subject.
* `tidy_data` is created by grouping and summarizing `all_data`, taking the means of each variable for each activity and each subject.

```r
tidy_data <- all_data %>%
  dplyr::group_by(subject, activity) %>%
  dplyr::summarise(across(everything(), mean))
```

## Write the resulting data set to a file.
* Export `tidy_data` into `tidy_data.txt` file.

```r
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
```

