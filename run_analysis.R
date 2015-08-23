library(plyr)
library(data.table)
# Reads the training and the test sets.
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
features.dat <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
# Merges the training and the test sets.
x_set <- rbind(x_train, x_test)
y_set <- rbind(y_train, y_test)
sub_set <- rbind(sub_train, sub_test)
whole_set <- cbind(y_set, sub_set, x_set)
names(whole_set) <- c("Activity", "Subject",as.character(features.dat[,2]))
# Release memories
rm(x_train, y_train, sub_train, x_test, y_test, sub_test, x_set, y_set, sub_set)
#
activity_IDs <- whole_set[,"Activity"]
activity_Factors <- as.factor(activity_IDs)
activity_Factors = revalue(activity_Factors, c("1"="WALKING", "2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"))
whole_set[,"Activity"] = activity_Factors
tidy_Dat <- data.table(whole_set)
avg_Tidydat <- tidy_Dat[, lapply(.SD,mean), by=c("Activity","Subject")]
write.table(avg_Tidydat, file="MeasureAvgTidySet.txt", row.names = FALSE)
write.csv(avg_Tidydat, file="MeasureAvgTidySet.csv", row.names = FALSE)