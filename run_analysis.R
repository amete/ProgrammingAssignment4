# Load the required packages, download if not existing
if(!require(data.table)) {
    install.packages("data.table")
}
if(!require(tidyr)) {
    install.packages("tidyr")
}
if(!require(dplyr)) {
    install.packages("dplyr")
}

# Read the data for the training and testing sets and merge them 
# Assuming colmns are the same measurements we make a simple bind_rows
training_data <- tbl_df(fread("UCI HAR Dataset/train/X_train.txt"))
testing_data  <- tbl_df(fread("UCI HAR Dataset/test/X_test.txt"))
all_data      <- bind_rows(training_data,
                           testing_data)

# Delete the seperate data that are not needed anymore from memory
rm(list = c("training_data","testing_data")) 

# Read the features giving name to each column
# Select only those that have mean() and std() in their feature name
# and subset the dataset accordingly and name the columns
# Store the selected data in selected_data, all else gets deleted
features_data  <- tbl_df(fread("UCI HAR Dataset/features.txt"))
feature_names  <- as.data.frame(features_data)[,2]

search_by_name <- grepl("mean\\(\\)|std\\(\\)",feature_names)

selected_names <- feature_names[which(search_by_name)]
selected_data  <- select(all_data,which(search_by_name))
names(selected_data) <- selected_names

# Delete the data that are not needed anymore from memory
rm(list = c("features_data",
            "all_data",
            "search_by_name",
            "feature_names",
            "selected_names"))

# Now come to the activities, first load the data
# then combine training and testing. Be careful,
# the order matters (same order as above). 
# Then bind the tables and label the new column as activityID
# which will be used to match the names to activities
training_activity_data <- tbl_df(fread("UCI HAR Dataset/train/y_train.txt"))
testing_activity_data  <- tbl_df(fread("UCI HAR Dataset/test/y_test.txt"))
all_activity_data      <- bind_rows(training_activity_data,
                                    testing_activity_data) # watch the order!!!
names(all_activity_data) <- "activityID"
selected_data            <- bind_cols(selected_data,
                                      all_activity_data)

# Delete the data that are not needed anymore from memory
rm(list = c("training_activity_data",
            "testing_activity_data",
            "all_activity_data")) 

# Add Activity names as a column activityName and delete activityID
activity_labels <- tbl_df(fread("UCI HAR Dataset/activity_labels.txt"))
activity_names  <- as.data.frame(activity_labels)[,2]
selected_data   <- mutate(selected_data, activityName = activity_names[activityID])
selected_data   <- selected_data %>%
                    mutate(activityName = activity_names[activityID]) %>%
                    select(-activityID)
rm(list = c("activity_labels",
            "activity_names")) # not needed anymore

# Now add the subject IDs
training_subject_data <- tbl_df(fread("UCI HAR Dataset/train/subject_train.txt"))
testing_subject_data  <- tbl_df(fread("UCI HAR Dataset/test/subject_test.txt"))
all_subject_data      <- bind_rows(training_subject_data, 
                                   testing_subject_data) # watch the order!!!
names(all_subject_data) <- "subjectID"
selected_data           <- bind_cols(selected_data, 
                                     all_subject_data)
rm(list = c("training_subject_data",
            "testing_subject_data",
            "all_subject_data")) # not needed anymore

# Name the variables in a meaningful way
raw_names <- names(selected_data)
nice_names <- raw_names %>% 
    { gsub("^t","time",.) } %>%
    { gsub("^f","frequency",.) } %>%
    { gsub("Acc","Accelerometer",.) } %>%
    { gsub("Gyro","Gyroscope",.) } %>%
    { gsub("-mean\\(\\)-","Mean",.) } %>%
    { gsub("-std\\(\\)-","StandardDeviation",.) } %>%
    { gsub("-mean\\(\\)","Mean",.) } %>%
    { gsub("-std\\(\\)","StandardDeviation",.) } %>%
    { gsub("Mag","Magnitude",.) }
names(selected_data) <- nice_names
rm(list = c("raw_names",
            "nice_names")) # not needed anymore

# Now melt and cast as per part 5)
melted_data <- melt(selected_data, 
                    id = c("subjectID","activityName"))
tidy_data   <- dcast(melted_data, subjectID + activityName ~ variable, mean)
rm(list = "melted_data")

# Write out the data for future use
write.table(selected_data, file = "./selected_data.txt")
write.table(tidy_data, file = "./tidy_data.txt",row.name=FALSE)