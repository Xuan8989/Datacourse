# download the zip file pertaining the data collected through Samsung Galacy S smartphone
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/smartphone.zip")

# unzip the file 
unzip(zipfile = "./data/smartphone.zip", exdir = "./data")

# Read the files 
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Adding names to the variables 
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
colnames(activities) <- c("activityID", "activityitem")

# Merge the datasets 
train <- cbind(x_train, y_train, subject_train)
test <- cbind(x_test, y_test, subject_test)
wholedataset <- rbind(train, test)

# select only the mean and standard deviation from the data set 
namesfromdata <- colnames(wholedataset)
meanandstd <- (grepl("mean..", namesfromdata) | grepl("std..", namesfromdata) | grepl("activityID", namesfromdata) | grepl("subjectID", namesfromdata))

newdataset <- wholedataset [, meanandstd == TRUE]

# Add activity items to the new data set 
activitywithIDs <- merge(newdataset, activities, by = "activityID", all.x = TRUE)

# Create tidy data set and translate into txt file 
tidydata <- aggregate(. ~activityID + subjectID, newdataset, mean)
write.table(tidydata, "tidydata.txt", row.names = FALSE)


