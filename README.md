Tidy-Data-Project
=================

Code Project for Getting and Cleaning Data course [Coursera]

To run this analysis, please place the run_analysis.R file and UCI HAR Dataset
directory in your working directory. The script works as follows:

First all relevant files are read into data frames with appropriate column header
using the col.names argument in read.table. The col.names are read from 
features.txt file provided with the data. Any illegal characters in these names 
are replaced by "." in the column header.

In order to improve the performance of read.table, we create a vector of column 
classes by reading first 5 rows of the the train dataset to obtain the class 
of each column.

For step 1 we use the cbind and rbind functions to merge the training and the 
test datasets to create one data set

For step 2 we get column names that contain -mean() and -std() to extract only 
the measurements on the mean and standard deviation for each measurement. It is
important to search for "-mean()" instead of "mean" since we do not want to
include variables having "meanFreq" or "angle" in their names.

We then extract these columns including subject and activity columns and create
a subset, called tidy_data, of the data.

For step 3, the activity column in tidy_data is updated by replacing the acitivity 
codes by activity names. This is done by factoring the activity column and 
giving each factor the label obtained from the activity_labels.txt

For step 4, we convert the column names to lower camel case and make them more
descriptive e.g. by replacing "t" with "time" and "f" with "freq". We do not want
to create very long names as they do not remain very human-readable even with 
camel case. Hence, we do not expand words like Acc, Gyro, Jerk.

For step 5 we use the aggregate function to create a dataset with the average of
each variable for each activity and each subject. This dataset is written to a
file named "tidy.txt" in the working directory.

