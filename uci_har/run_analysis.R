require(reshape2)
require(plyr)

# set the current working directory 
setwd("~/jhuGetData/uci_har/")

# Read in the training data, test data, subject labels,
# and feature labels
trainSet <- read.table("train/X_train.txt")  # training
trainLabels <- read.table("train/y_train.txt") # train
testSet <- read.table("test/X_test.txt")
testLabels <- read.table("test/y_test.txt")
subjTrain <- read.table("train/subject_train.txt")
subjTest <- read.table("test/subject_test.txt")
features <- read.table("features.txt")
act <- read.table("activity_labels.txt", stringsAsFactors = F)

# Get the label indices with "mean" or "std" in the name
subVec <- features[grep("mean|std", features$V2),]

# Subset the training and test data using the subset vector
subTrain <- trainSet[,subVec$V2]
subTest <- testSet[,subVec$V2]

# Rename the columns before joining the subject lablels
colnames(subTrain) <- subVec$V2
colnames(subTest) <- subVec$V2
colnames(subjTrain) <- "subject"
colnames(subjTest) <- "subject"
colnames(trainLabels) <- "activity"
colnames(testLabels) <- "activity"

# Join the subjects to corresponding test and training data respectively
newTest <- cbind(subjTest, testLabels, subTest)
newTrain <- cbind(subjTrain, trainLabels, subTrain)

# Bind the two data sets together
allData <- rbind(newTest, newTrain)

# Rename the activities
replaced <- mapvalues(allData$activity, act$V1, act$V2)
allData$activity <- replaced

# Create a dataset holding the mean by subject and variable
meltAll <- melt(allData, id = c("subject", "activity"))
allMeans <- dcast(meltAll, subject + activity ~ variable, mean)

# Write tidy datasets
write.table(allData, "all_data_tidy.txt")
write.table(allMeans, "all_means_tidy.txt")

