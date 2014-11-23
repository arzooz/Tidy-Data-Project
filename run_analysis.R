# Read all relevant files into data frames and add appropriate column names 

activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')
features <- read.table('UCI HAR Dataset/features.txt')

subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', col.names="subject")
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', col.names="activity")

# Read in 5 rows of the table to create a vector of classes for improving the
# performance of read.table
temp <- read.table("UCI HAR Dataset/train/X_train.txt", nrows = 5)
classes <- sapply(temp, class)

x_train <- read.table('UCI HAR Dataset/train/X_train.txt', col.names=features$V2, colClasses = classes)

subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', col.names="subject")
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', col.names="activity")
x_test <- read.table('UCI HAR Dataset/test/X_test.txt', col.names=features$V2, colClasses = classes)


## STEP 1: Merge the training and the test sets to create one data set

train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)
data <- rbind(train_data, test_data)


## STEP 2: Extract only the measurements on the mean and standard deviation
## for each measurement

# Columns names with -mean() 
mean_cols <- grep("\\.mean\\.\\.", names(data))

# Columns names with -std()
std_cols <- grep("\\.std\\.\\.", names(data))

# Columns to extract including subject and activity columns
extract <- c(1, 2, mean_cols, std_cols) 

tidy_data <- data[, extract]


## Step 3: Use descriptive activity names to name the activities in the data set

tidy_data$activity <- as.factor(tidy_data$activity)
levels(tidy_data$activity) <- activity_labels$V2


## Step 4: Appropriately label the data set with descriptive variable names

# The argument col.names=features$V2 in creating x_train and x_test data frames 
# creates column header with feature names from which the illegal characters have 
# been removed and replaced by ".". 
# Converting these names to lower camel case

names(tidy_data) <- gsub(".mean", "Mean", names(tidy_data))
names(tidy_data) <- gsub(".std", "Std", names(tidy_data))
names(tidy_data) <- gsub("\\.", "", names(tidy_data))
names(tidy_data) <- gsub('^t', 'time', names(tidy_data))
names(tidy_data) <- gsub('^f', 'freq', names(tidy_data))
names(tidy_data) <- gsub('BodyBody', 'Body', names(tidy_data))


## Step 5: From the data set in step 4, create a second, independent tidy data 
## set with the average of each variable for each activity and each subject

avg_tidy_data <- aggregate(tidy_data[,3:ncol(tidy_data)],tidy_data[,1:2], FUN=mean)

write.table(avg_tidy_data, file="tidy.txt", row.name=FALSE)