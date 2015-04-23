train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

data = rbind(train, test)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

cols <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[cols,]
cols <- c(cols, 562, 563)
data <- data[,cols]
colnames(data) <- c(features$V2, "Activity", "Subject")
colnames(data) <- tolower(colnames(data))

activity = 1
for (currentActivityLabel in activityLabels$V2) {
  data$activity <- gsub(activity, currentActivityLabel, data$activity)
  activity <- activity + 1
}

data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)

cleanData = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)
write.table(cleanData, "cleanData.txt", sep="\t", row.name = FALSE)