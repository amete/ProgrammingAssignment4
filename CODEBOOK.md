# CODEBOOK

This is the codebook that describes the code documented in this repository for the "Peer-graded Assignment: Getting and Cleaning Data Course Project".

## The Data

* Original description of the data: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
* Original source of the data: [Data_file.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Brief

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

See "UCI HAR Dataset/README.txt" for more details.

## The Cleaning Code

There is a single R script named "run_analysis.R". Before executing, make sure you set your work directory to the folder that contains this file.

As a result of the execution the user will get two datasets:
* selected_data : This dataset contains a total of 68 variables for 10299 observations. From the original dataset, we only retained the mean [mean()] and standard deviation [std()] for each measurement that is summarized in "UCI HAR Dataset/features_info.txt". The naming convention follows the original one closely, where time domain signals begin with time and frequency domain signals begin with frequency. This is followed by either Body or Gravity to denote the body and gravity acceleration signals, respectively. The next part of the variable name is devoted to either Accelerometer or Gyroscope, denoting the source of the signal. The last part of the varible names are reserved for Mean and StandardDeviation that summarizes the nature of the measurement and the last to X,Y,Z denoting the Euclidean coordinate for the measurement. 
* tidy_data : This dataset contains a total of 68 variables for 180 observations. There are 30 volunteers each performing 6 different activities. Each combination is an observation in the dataset, which is cast by subjectID (volunteer ID) and activityName (activity name) and each variable holds the average of each feature.

These datasets are also writted into text files for future use if needed.

### Transformation details

The code performs the following actions:

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

