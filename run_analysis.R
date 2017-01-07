#
#Merges the training and the test sets to create one data set.
#
#install.packages("plyr", dependencies = TRUE)

library(plyr)
xtrain <- read.table("Dataset/train/X_train.txt")
ytrain <- read.table("Dataset/train/y_train.txt")
subjecttrain <- read.table("Dataset/train/subject_train.txt")

xtest <- read.table("Dataset/test/X_test.txt")
ytest <- read.table("Dataset/test/y_test.txt")
subjecttest <- read.table("Dataset/test/subject_test.txt")

# creating 'x' data set
xdata <- rbind(xtrain, xtest)
# creating 'y' data set
ydata <- rbind(ytrain, ytest)

# creating 'subject' data set
subjectdata <- rbind(subjecttrain, subjecttest)

#
#Extracts only the measurements on the mean and standard deviation for each measurement.
#
features <- read.table("Dataset/features.txt")

# get only columns with mean() or std() names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the columns
xdata<- xdata[, mean_std_features]

#column names  correction 
names(xdata)<- features[mean_std_features, 2]

#
#Uses descriptive activity names to name the activities in the data set
#
activities<- read.table("Dataset/activity_labels.txt")

# updating values with correct activity names
ydata[, 1]<- activities[ydata[, 1], 2]

# correcting column name
names(ydata)<- "activity"

#
#Appropriately labels the data set with descriptive variable names.
#
# correcting column name
names(subjectdata) <- "subject"

# binding all the data into asingle data set
alldata<- cbind(xdata, ydata, subjectdata)

#
#creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
#
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averagesdata, "tidy_average_data.txt", row.name=FALSE)




