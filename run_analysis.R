## Step 1: Merges the training and the test sets to create one data set.

## Read in training data
subject_train=read.table(file = "train/subject_train.txt", col.names="subject")
y_train= read.table(file = "train/y_train.txt", col.names="label")
x_train= read.table(file = "train/x_train.txt")

## Read in test data
subject_test=read.table(file = "test/subject_test.txt", col.names="subject")
y_test= read.table(file = "test/y_test.txt", col.names="label")
x_test= read.table(file= "test/x_test.txt")

## Combine both sets of data
data= rbind(cbind(subject_train, y_train, x_train), cbind(subject_test, y_test, x_test))



## Step 2 Extracts only the measurements on the mean and standard deviation for each measurement.

## relevant columns identified
relevant_feature_index= c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543)
## new array created containing only subject, task label and relevant features
data_meansd=data[, c(1,2, relevant_feature_index+2)]




## Step 3 Uses descriptive activity names to name the activities in the data set
activity_labels = read.table(file = "activity_labels.txt", stringsAsFactors=FALSE)
data_meansd$label <- activity_labels[data_meansd$label, 2]



## Step 4 Appropriately labels the data set with descriptive variable names. 
features= read.table(file = "/features.txt", stringsAsFactors=FALSE)
variables <- c("subject", "activity", features[relevant_feature_index, 2])
variables <- gsub("[[:punct:]]", " ", variables)
colnames(data_meansd) <- variables



## Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggregatedata <-aggregate(data_meansd[, 3:ncol(data_meansd)], 
                    by=list(subject= data_meansd$subject, activity=data_meansd$activity), FUN=mean)


write.table(x = aggregatedata,file = "data.txt", row.name=FALSE)

