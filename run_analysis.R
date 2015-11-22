#setwd("C:/selfdev/Coursera/Course 3 - Getting and Cleaning Data/Week 3")

require(plyr)

#Read in all the data first
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
feature_labels<-read.table("./UCI HAR Dataset/features.txt",colClasses = c("character"))

#1.Merges the training and the test sets to create one data set.
#first, merge the training data together
train_data<-cbind(cbind(x_train, subject_train), y_train)
#next, merge the test data 
test_data<-cbind(cbind(x_test, subject_test), y_test)
#combine test and training data
merged_data<-rbind(train_data, test_data)
#fix the labels
merged_labels<-rbind(rbind(feature_labels, c(562, "Subject")), c(563, "Id"))[,2]
names(merged_data)<-sensorlabels

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
merged_datameanstd <- merged_data[,grepl("std\\(\\)|mean\\(\\)|Subject|Id", names(merged_data))]

#3. Uses descriptive activity names to name the activities in the data set
merged_datameanstd <- join(merged_datameanstd, activity_labels, by = "Id", match = "first")
merged_datameanstd <- merged_datameanstd[,-1]

#4. Appropriately labels the data set with descriptive names.
#strip the braces in the names
names(merged_datameanstd) <- gsub("([()])","",names(merged_datameanstd))
names(merged_datameanstd) <- make.names(names(merged_datameanstd), unique = TRUE, allow_ = TRUE)

#5. From the data set in step 4, creates a second, independent tidy data set 
result_data<-ddply(merged_datameanstd, c("Subject","Activity"), numcolwise(mean))
result_dataheaders<-names(result_data)
names(result_data)<-result_dataheaders

write.table(result_data, file = "merged_data_avg_by_subject.txt", row.name=FALSE)