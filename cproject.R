setwd("~/Desktop/data science/john hopkins course/Getting and Cleaning Data/course project/")

library(data.table)
library(plyr)
library(dplyr)

#Import the Train and Test datasets:
DT_train_data <- fread("./data/UCI HAR Dataset/train/X_train.txt")
DT_test_data <- fread("./data/UCI HAR Dataset/test/X_test.txt")
str(DT_train_data)

#Import the activity labels coresponding to each measurement:
DT_train_labels <- fread("./data/UCI HAR Dataset/train/Y_train.txt")
DT_test_labels <- fread("./data/UCI HAR Dataset/test/Y_test.txt")

setnames(DT_train_labels,"V1","label")
setnames(DT_test_labels,"V1","label")

table(DT_train_labels)
table(DT_test_labels)

#Import the subject number for each measurement:
DT_train_subject <- fread("./data/UCI HAR Dataset/train/subject_train.txt")
DT_test_subject <- fread("./data/UCI HAR Dataset/test/subject_test.txt")

setnames(DT_train_subject,"V1","subject")
setnames(DT_test_subject,"V1","subject")

table(DT_train_subject)
table(DT_test_subject)

#Import the column names of the measurements and their derivatives:
DT_features <- fread("./data/UCI HAR Dataset/features.txt")

#Change the column names of the data:
setnames(DT_train_data,DT_features$V2)
setnames(DT_test_data,DT_features$V2)

DT_train_complete <- cbind(set = c(rep("train",length(DT_train_labels$label))),DT_train_labels,DT_train_subject,DT_train_data)
DT_test_complete <- cbind(set = c(rep("test",length(DT_test_labels$label))),DT_test_labels,DT_test_subject,DT_test_data)

#Task 1:
DT_data_complete <- rbind(DT_test_complete,DT_train_complete)

#Task 2:
mean_data <- grep("mean", colnames(DT_data_complete), perl = TRUE, value = FALSE)
std_data <- grep("std", colnames(DT_data_complete), perl = TRUE, value = FALSE)

keep_columns <- sort(c(1,2,3,mean_data,std_data))
DT_mean_std <- DT_data_complete[,keep_columns, with = FALSE]

#Task 3:
activity_labels <- fread("./data/UCI HAR Dataset/activity_labels.txt")
DT_mean_std$label <- as.factor(DT_mean_std$label)
DT_mean_std$label <- mapvalues(DT_mean_std$label, from = activity_labels$V1, to = activity_labels$V2)

#Task 4: has already been accomplished
names(DT_mean_std)

#Task 5:

grp_data <- as.data.frame(DT_mean_std) %>% group_by(subject, label)
tidy_data <- grp_data %>% summarise_each(funs(mean), (4:length(names(grp_data))))
write.table(tidy_data, file = "tidy_data.txt")
write.table(names(tidy_data), file="startcodebook.md")
