**Dataset Information**

Overview: 

The original dataset was sourced from the Human Activity Recognition Using Smartphones project, where data was collected from 30 volunteers (aged 19-48) performing six distinct activities while carrying a smartphone (Samsung Galaxy S II) on their waist. The smartphone’s embedded accelerometer and gyroscope recorded data at a 50Hz rate. Activities included:


WALKING

WALKING_UPSTAIRS

WALKING_DOWNSTAIRS

SITTING

STANDING

LAYING

The dataset was split into training (70%) and test (30%) sets. Data preprocessing included noise filtering and sampling into sliding windows (2.56 seconds with 50% overlap, equating to 128 readings per window). Body and gravity components were separated using a low-pass filter, where gravity was filtered to low-frequency components (cutoff at 0.3 Hz).

**Files in the Original Dataset**

The dataset includes the following files:

README.txt: Describes the dataset.

features_info.txt: Details on each feature used.

features.txt: Full list of features.

activity_labels.txt: Maps activity names to labels.

train/X_train.txt: Training data set.

train/y_train.txt: Training labels.

test/X_test.txt: Test data set.

test/y_test.txt: Test labels.

train/subject_train.txt: Lists the subject ID for each training sample.

test/subject_test.txt: Lists the subject ID for each test sample.

Additionally, the Inertial Signals folder in both train and test directories contains files with triaxial measurements for the X, Y, and Z axes, including:

total_acc_x_train.txt, total_acc_y_train.txt, total_acc_z_train.txt

body_acc_x_train.txt, body_acc_y_train.txt, body_acc_z_train.txt

body_gyro_x_train.txt, body_gyro_y_train.txt, body_gyro_z_train.txt

**Data Transformation and Cleaning**

Tasks Performed in the Script

Data Merging: Combined training and test sets to create one comprehensive dataset.

Feature Extraction: Selected only mean and standard deviation measurements for each observation.

Activity Labeling: Added descriptive activity names to the dataset for clarity.

Descriptive Variable Naming: Renamed variables with descriptive names.

Independent Tidy Dataset Creation: Generated a secondary dataset with the average of each variable for each activity and subject.

**Walkthrough of Transformation Process**

Installation and Data Retrieval: Downloaded and loaded data using download.file() and fread() functions.

Feature Selection: Extracted mean and standard deviation measurements using grep on variable names in features.txt.

Column Labeling: Assigned descriptive variable names to the dataset by substituting abbreviations with full names using gsub():

"t" → "Time"

"f" → "Frequency"

"Acc" → "Accelerometer"

"Gyro" → "Gyroscope"

"Mag" → "Magnitude"

"BodyBody" → "Body"

"()" → ""

Merging Data: Used rbind() to combine the training and test data.

Creating Tidy Data: Converted Activity and Subject columns to factors, then reshaped the dataset using the reshape library’s melt() and dcast() functions to compute averages.

**Final Output**

The final, tidy dataset includes an average of each measurement for each activity and each subject. This dataset is written to tidyData.txt.
