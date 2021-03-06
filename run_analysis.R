################################################
### elab date: 20/03/2017
### Name: Verónica Vaca
### Project Getting and Cleanning Data
################################################

library(plyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
file_name <-"Dataset.zip" 

# Downloading the file if not exists already

if (!file.exists(file_name)){
        download.file(file_url, destfile = "./Dataset.zip", method = "curl")
}

#unzip the zip file

if (!file.exists("./Dataset")) { 
        unzip(file_name) 
}


## 1.1  Reading the Data

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

### 1.2 create 'x' data set

x_data <- rbind(x_train, x_test)

### 1.3 create 'y' data set

y_data <- rbind(y_train, y_test)

### 1.4 create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

### cleanning

rm(x_train,y_train,subject_train,x_test,y_test,subject_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

### cleaning

rm(x_data,y_data,subject_data,features,mean_and_std_features)
gc()

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)

