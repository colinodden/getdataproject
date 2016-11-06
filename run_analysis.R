## This is run_analysis.R
## It operates on the Human Activity Recognition data held by the University of California, Irvine
## It performs the following actions:
### Merges the training and the test sets to create one data set.
### Extracts only the measurements on the mean and standard deviation for each measurement.
### Uses descriptive activity names to name the activities in the data set
### Appropriately labels the data set with descriptive variable names.
### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## November 2016, Colin Odden, colin.odden@osumc.edu

# 0.1 Housekeeping
rm(list=ls())

require(dplyr)
require(tidyr)
require(reshape2)
require(tools)

dir_root <- "C:\\Users\\colin\\Documents\\"
setwd(dir_root)
debug <- TRUE

# 0.2 Acquisition
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_zip = "dataset.zip"
download.file(url, file_zip, mode="wb")
unzip (file_zip) # default unzip path -- yields "dir_root/UCI HAR Dataset/"

# 0.3 Load files
train_x <-   read.table("UCI HAR Dataset/train/X_train.txt", comment.char="")
train_y <-   read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("activity"))
test_x <-    read.table("UCI HAR Dataset/test/X_test.txt", comment.char="")
test_y <-    read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity"))
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
test_sub <-  read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
features <-  read.table("UCI HAR Dataset/features.txt", col.names=c("id","label"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "name"))

# 0.4 Assign colnames to train_x
colnames(train_x) <- features[,2]
colnames(test_x) <- features[,2]

# 1 Merge train and test datasets
## Merge test and train wide
data_test <- cbind(test_x, test_sub, test_y)
if(debug) str(data_test)
data_train <- cbind(train_x, train_sub, train_y)
if(debug) str(data_train)
## merge them both long
data_all <- rbind(data_test, data_train)
if(debug) str(data_all)
## use 'features' for labelling
features_vect <- c(as.vector(features[,"label"]), "subject","activity") # gets crude names like "fBodyGyro-bandsEnergy()-41,48"

# 2 Create dataset comprising only mean/sd for each measurement
#features_clean <- gsub("\(","",features_vect)
features_keep <- grepl("mean|std|subject|activity", features_vect) & !grepl("Freq", features_vect)
data_use = data_all[, features_keep]
if(debug) str(data_use)

# 3 Label activities meaningfully
act_tmp <- tolower(activities[,"name"])
act_tmp <- gsub("_","\ ",act_tmp)

# 4 Create appropriately descriptive variable names
## I could have done this better -- there's a mix of CamelCase and hyphens here
colNames <- colnames(data_use)
for (i in 1:length(colNames)) {
  colNames[i] = gsub("\\()","", colNames[i])
  colNames[i] = gsub("-std","-StdDev", colNames[i])
  colNames[i] = gsub("-mean","-Mean", colNames[i])
  colNames[i] = gsub("^(t)","time-", colNames[i])
  colNames[i] = gsub("^(f)","freq-", colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity", colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body", colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro", colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude", colNames[i])
  colNames[i] = gsub("Acc", "-Acceleration", colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude", colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude", colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude", colNames[i])
  }
colNames

write.table(data_use, "data_merged.txt", row.name=FALSE)


# 5 Create a tidy version of the dataset
## per Wickham(2014), this is equivalent to Codd's 3rd normal form for relational data:
##  1. Each variable forms a column.
##  2. Each observation forms a row.
##  3. Each type of observational unit forms a table.

# First, tackle collapsing to means at the subj-act level
data_melt <- melt(data_use, id = c("subject", "activity")) ## reshape long so we can easily summarize across act*var*val
data_collapsed <- dcast(data_melt, subject + activity ~ variable, mean)
dim(data_collapsed)

write.table(data_collapsed, "data_collapsed.txt", row.name=FALSE)

# fin!
