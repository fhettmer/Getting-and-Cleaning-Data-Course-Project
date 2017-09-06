library(data.table)
library(plyr)
##Step1a: Read data sets.

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<- read.table("./UCI HAR Dataset/train/y_train.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_data <- rbind(subject_train, subject_test)

features <- read.table("./UCI HAR Dataset/features.txt")

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

##Step1b: Merging the training and the test sets to create a data set for each x and y.

x_data<-rbind(X_train, X_test)
y_data<-rbind(y_train, y_test)

##Step2: Extracting the measurements on the mean and standard deviation for each measurement.

mean<-list(grep("mean", features$V2))
std<-list(grep("std", features$V2))

##Step3: Using descriptive activity names to name the activities in the data set.
y_data[, 1] <- activities[y_data[, 1], 2]


##Step4: Appropriately labels the data set with descriptive variable names. 
names(subject_data) <- "subject"
names(y_data) <- "activity"

##Step5: Creating a second data set from the data set in step 4 with the average of each variable 
## for each activity and each subject.
all_data <- cbind(x_data, y_data, subject_data)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)