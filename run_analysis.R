library(plyr)

###############################################################################
# First Step - Read test and train sets and merge them
###############################################################################

x_training <- read.table("train/X_train.txt")
y_training <- read.table("train/y_train.txt")

subject_training <- read.table("train/subject_train.txt")

x_testing <- read.table("test/X_test.txt")
y_testing <- read.table("test/y_test.txt")

subject_testing <- read.table("test/subject_test.txt")

# Create an x and y datasets
x_data <- rbind(x_training, x_testing)
y_data <- rbind(y_training, y_testing)

# Create a dataset for subject
subject_data <- rbind(subject_training, subject_testing)

###############################################################################
# Second Step - Extract only measurements on the mean and standard deviation for each
###############################################################################

features <- read.table("features.txt")

# Only get columns with mean or std in their names
mean_and_std_feat <- grep("-(mean|std)\\(\\)", features[, 2])

x_data <- x_data[, mean_and_std_feat]

# Correction of the column names
names(x_data) <- features[mean_and_std_features, 2]

###############################################################################
# Third Step - Use descriptive activity names to name the activities in the dataset
###############################################################################

activities <- read.table("activity_labels.txt")

# Update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# Correct column name
names(y_data) <- "activity"

###############################################################################
# Four Step - Appropriately label the dataset with descriptive variable names
###############################################################################

# Correct column name
names(subject_data) <- "subject"

# Get all  data in a single dataset
all_data <- cbind(x_data, y_data, subject_data)

###############################################################################
# Fifth Step - Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
