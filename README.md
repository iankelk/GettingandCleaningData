
Getting and Cleaning Data Course Project
==========================================

* This is the course project for the Getting and Cleaning Data Coursera course.
* The included R script, `run_analysis.R`, runs the following:

### Files

* Data set [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
* `CodeBook.md` a code book that describes the variables, the data, and all transformations performed to clean up the data.
* `run_analysis.R` performs the data preparation and then followed by the 5 steps required as described in the course project's definition:
  * Merges the training and the test sets to create one data set.
  * Extracts only the measurements on the mean and standard deviation for each measurement.
  * Uses descriptive activity names to name the activities in the data set
  * Appropriately labels the data set with descriptive variable names.
  * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* `tidy_data.txt` a tidy data set that consists of the mean of each variable for each subject and each activity.