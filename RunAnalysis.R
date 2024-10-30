# This script performs the following tasks:
# 1. Combines training and test datasets into one comprehensive dataset.
# 2. Selects only the columns that measure mean and standard deviation for each observation.
# 3. Assigns descriptive names to the activities within the dataset.
# 4. Provides descriptive variable names for each measurement.
# 5. Creates a new, independent dataset that contains the average of each variable for each activity and each subject.

# Load required packages (data.table and reshape2)
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(data.table, reshape2, gsubfn)

# Download and extract data from the provided URL
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

# Read activity labels and features information
activityLabels <- fread(
  file.path(path, "UCI HAR Dataset/activity_labels.txt"),
  col.names = c("classLabels", "activityNames")
)

features <- fread(
  file.path(path, "UCI HAR Dataset/features.txt"),
  col.names = c("index", "featureNames")
)

# Identify mean and standard deviation measurements in features
featuresNeeded <- grep("(mean|std)\\(\\)", features[, featureNames])
selectedMeasurements <- features[featuresNeeded, featureNames]
selectedMeasurements <- gsubfn(
  "(^t|^f|Acc|Gyro|Mag|BodyBody|\\(\\))",
  list(
    "t" = "Time",
    "f" = "Frequency",
    "Acc" = "Accelerometer",
    "Gyro" = "Gyroscope",
    "Mag" = "Magnitude",
    "BodyBody" = "Body",
    "()" = ""
  ),
  selectedMeasurements
)

# Load and prepare training data
trainData <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresNeeded, with = FALSE]
setnames(trainData, colnames(trainData), selectedMeasurements)

activityTrain <- fread(file.path(path, "UCI HAR Dataset/train/y_train.txt"), col.names = "Activity")
subjectTrain <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = "SubjectNo.")

trainData <- cbind(activityTrain, subjectTrain, trainData)

# Load and prepare test data
testData <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresNeeded, with = FALSE]
setnames(testData, colnames(testData), selectedMeasurements)

activityTest <- fread(file.path(path, "UCI HAR Dataset/test/y_test.txt"), col.names = "Activity")
subjectTest <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = "SubjectNo.")

testData <- cbind(activityTest, subjectTest, testData)

# Combine the test and train data
mergedData <- rbind(trainData, testData)

# Convert Activity and Subject columns to factor type using activity labels
mergedData[["Activity"]] <- factor(mergedData[, Activity], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityNames"]])
mergedData[["SubjectNo."]] <- as.factor(mergedData[, SubjectNo.])

# Reshape the data: Melt and recast to calculate the average for each variable by subject and activity
mergedData <- melt.data.table(mergedData, id=c("SubjectNo.", "Activity"))
tidyData <- dcast(mergedData, SubjectNo. + Activity ~ variable, mean)

# Export the final tidy dataset to a text file
fwrite(tidyData, file="tidyData.txt")
