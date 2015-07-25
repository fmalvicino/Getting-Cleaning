# Getting-Cleaning Data
## Readme file. "How run_analysis.R works"

run_analysis.R (raR) uses 6 libraries (reshape2, data.table, plyr, dplyr, tidyr, stringr). If any of them has not been installed, it might be added using "install.packages()" in R.

First, the Script reads the train and test datasets. The it merges them and finally it uses features names to set the variable (columns) names.

Then it extracts only the measurements on the mean and standard deviation for each measurement. This can be achieved selecting variables that contain the word 'mean' or 'std' in their names.

To uses descriptive activity names to name the activities in the data set, the raR uses the merge function with the activity description file and the dataset created in the step described above.

To turn the variable names into descriptive ones, raR replaces the 'short names' with appropriate labels.

Finally, raR creates an independent tidy data set with the average of each variable for each activity and each subject. A txt file with the data set is created and saved into the working directory.






