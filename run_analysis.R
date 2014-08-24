#      This is R script 'run_analysis.R'
# Single script -- requires() and includes() no other programs
# Libraries required:
#   tools
# User must set only one variable: the value specified by setwd()
#  All paths are relative; only the base directory must be set
# Outputs is a file 'tidydata.txt'
setwd("/Volumes/WYRK/BOX/R/getdata/project")

# name our outputs here
bigdata <- "./data/data_big.txt"
tidydata <- "./data/data_tidy.txt"

# create data subdirectory, if it doesn't exist
if (!file.exists("data")) { dir.create("data")}

# does the data appear to exist?
# if not, download it to data.zip. Unzip it without subdirectories (unzip flat). Remove the zip.
if (!file.exists("./data/X_test.txt")) {
  target <- "./data.zip"
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile=target)
  unzip("./data.zip", exdir="./data", junkpaths=TRUE) # NB: Unzips flat!
  unlink("./data.zip")
  library(tools)       # for md5 checksum
  sink("download_metadata.txt")
  print("Download date:")
  print(Sys.time() )
  print("Download URL:")
  print(target_url)
  print("Downloaded file Information")
  print(file.info(target))
  print("Downloaded file md5 Checksum")
  print(md5sum(target))
  sink()  
}

# read some files!
df_train <- read.table("./data/X_train.txt")
dim(df_train) # 7352*561
head(df_train)
labels_train <- read.table("./data/y_train.txt")
table(labels_train)
trainSubject <- read.table("./data/subject_train.txt")
df_test <- read.table("./data/X_test.txt")
labels_test <- read.table("./data/y_test.txt") 
table(labels_test) 
testSubject <- read.table("./data/subject_test.txt")

# merge some files!
df_joined <- rbind(df_train, df_test)
label_joined <- rbind(labels_train, labels_test)
joinSubject <- rbind(trainSubject, testSubject)

# read some indicators, clean them, apply them.
features <- read.table("./data/features.txt")
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
df_joined <- df_joined[, meanStdIndices]
names(df_joined) <- gsub("-", "", names(df_joined))
names(df_joined) <- gsub("\\(\\)", "", features[meanStdIndices, 2])
names(df_joined) <- gsub("mean", "Mean", names(df_joined))
names(df_joined) <- gsub("std", "Std", names(df_joined))

activities <- read.table("./data/activity_labels.txt")
activities[, 2] <- tolower(gsub("_", "", activities[, 2]))
substr(activities[2, 2], 8, 8) <- toupper(substr(activities[2, 2], 8, 8))
substr(activities[3, 2], 8, 8) <- toupper(substr(activities[3, 2], 8, 8))
label_activities <- activities[label_joined[, 1], 2]
label_joined[, 1] <- label_activities
names(label_joined) <- "Activity"

names(joinSubject) <- "Subject"
df_clean <- cbind(joinSubject, label_joined, df_joined)
dim(df_clean) # 10299*68
# write out the 'big' data
write.table(df_clean, bigdata)

# Produce "tidy" data: mean of each column by subject/activity
# I used nested loops. Were this Stata, I'd use 'by' -- can't find R equiv.
num_subjects <- length(table(joinSubject))
num_activities <- dim(activity)[1]
num_columns <- dim(df_clean)[2]
result <- as.data.frame(
    matrix(NA, nrow=num_subjects*num_activities, ncol=num_columns))
colnames(result) <- colnames(df_clean)
row <- 1
for(i in 1:num_subjects) {
  for(j in 1:num_activities) {
    result[row, 1] <- sort(unique(joinSubject)[, 1])[i]
    result[row, 2] <- activity[j, 2]
    bool1 <- i == df_clean$subject
    bool2 <- activity[j, 2] == df_clean$activity
    result[row, 3:num_columns] <- colMeans(df_clean[bool1&bool2, 3:num_columns])
    row <- row + 1 # no increment operator in R!
  }
}
# write the 'tidy' dataset
write.table(result, tidydata)