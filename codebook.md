---
title: "UCI HAR Codebook"
author: "Colin Odden"
date: "November 6, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
# Human Activity Recognition

Summary: This file describes the Human Activity Recognition dataset (hereafter _UCI HAR_), the processing of the original data into a single summary file, and the contents of the the resultant file _tidydata.txt_.

##### Original data 2012, University of California, Irvine
##### Modified November 2016 by Colin Odden 

_Original Citation:_ Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

Original data were downloaded from http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip on October 31, 2016


##### Attribute Information
For each record in the dataset the following were recorded:
- Identifier for the research participant (subject).
- Name of the activity being performed. 
- Triaxial acceleration from the accelerometer (total acceleration), as well as the estimated body acceleration.
- The gyroscope's triaxial angular velocity from .
- A 561-feature vector with time and frequency domain variables.

### Data Processing
All data processing is :performed by _run_analysis.R_

_run_analysis.R_ performs the following operations:
* Downloads the UCI HAR data
* Applies variable labels for all variables,
* Merges, via appending, the fully-labeled 'test' and 'train' data sets,
* Subsets to only include means and standard deviations of each measure,
* Saves this data as _data_merged.txt_,
* Summarizes the data comprising "data_big.txt" by taking mean of each mean/standard deviation,
      for each Subject X Activity (thus, means are not column means but rather means across SubjXAct). The result is an activity-subject level file containing the means of the mean and standard deviation of the original subject-activity-observation level data.
* Saves this data as _data_collapsed.txt_


Variable names in the original data contained characters that either require escaping or are illegal in other analysis software. These were reduced to alphanumeric characters separated by dashes or underscores.


## Original Data
Experiments were conducted with a group of 30 volunteers spanning 19-48 years, inclusive. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, researchers captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data.

The UCI HAR data come as a set of files distinguished as 'testing' and 'training' data. This partitioning is random, where 70% of the volunteers was selected for generating the training data and 30% the test data. The testing and training data are merged "long" via appending. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Each record contains the following values:

    Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    Triaxial Angular velocity from the gyroscope.
    A 561-feature vector with time and frequency domain variables.
    Its activity label.
    An identifier of the subject who carried out the experiment.

The original dataset comprises the following files:

    ‘features_info.txt’: Shows information about the variables used on the feature vector.
    ‘features.txt’: List of all features.
    ‘activity_labels.txt’: Links the class labels with their activity name.
    ‘train/X_train.txt’: Training set.
    ‘train/y_train.txt’: Training labels.
    ‘test/X_test.txt’: Test set.
    ‘test/y_test.txt’: Test labels.
    ‘train/subject_train.txt’: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
    ‘train/Inertial Signals/total_acc_x_train.txt’: The acceleration signal from the smartphone accelerometer X axis in standard gravity units ‘g’. Every row shows a 128 element vector. The same description applies for the ‘total_acc_x_train.txt’ and ‘total_acc_z_train.txt’ files for the Y and Z axis.
    ‘train/Inertial Signals/body_acc_x_train.txt’: The body acceleration signal obtained by subtracting the gravity from the total acceleration.
    ‘train/Inertial Signals/body_gyro_x_train.txt’: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix ‘t’ to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). The magnitude of these signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the ‘f’ to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
‘-XYZ’ is used to denote 3-axial signals in the X, Y and Z directions.
