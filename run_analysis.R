#Installing packages if needed. ie: install.packages("data.table")

library(reshape2)
library(data.table)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)

#to run the script, set working directory where you have the folders with the files.
#The script assumes that the data source files are in the a directory called 
# "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/"
#Reading 'train'data
X_Train = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header = FALSE)
Y_Train = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt", header = FALSE)
Z_Train = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Reading 'test' data
X_Test = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE)
Y_Test = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt", header = FALSE)
Z_Test = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Labels
activity = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activity) = c("id", "Activity")
namescol = read.table(file = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE)

#Columns names from features
namescol2 = as.character(namescol$V2)
namescol2 = make.names(namescol2, unique = TRUE)
columns = c("Subject_ID", "Activity_Code", namescol2)
 
# 1- Merging datasets
Train = cbind(Z_Train, Y_Train, X_Train)
Test = cbind(Z_Test, Y_Test, X_Test)
TrainTest = rbind(Train, Test)
names(TrainTest) = columns


# 2- Extracts only the measurements on the mean and standard deviation for each measurement.
measurements = select(TrainTest, Subject_ID, Activity_Code, contains("mean"), contains("std"))

## 3- Uses descriptive activity names to name the activities in the data set
TrainTest2 = merge(activity, measurements, by.x = "id", by.y= "Activity_Code")
TrainTest3= select(TrainTest2,-id)

## 4- Appropriately labels the data set with descriptive variable names.
names(TrainTest3) <- str_replace_all(names(TrainTest3), "[.]", "")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "tBody", "Time Body ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "tGravity", "Time Gravity ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "Gyro", "Gyroscope ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "Acc", "Accelerator ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "Mag", " Magnitude")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "fGravity", "Freq Gravity ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "fBody", "Freq Body ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "mean", " Mean ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "std", " Standard Deviation ")
names(TrainTest3) <- str_replace_all(names(TrainTest3), "angle", "Angle ")

TrainTest4 = melt(TrainTest3, id.vars = c('Activity', 'Subject_ID'))


## 5- independent tidy data set with the average of each variable for each activity and each subject.
TrainTest5 = dcast(TrainTest4, Activity + Subject_ID ~ variable, mean)

write.table(TrainTest5, "Tidy-Data-Step5.txt", row.names = FALSE)

