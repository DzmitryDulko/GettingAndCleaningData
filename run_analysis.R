preprocess <- function() {
    dataDir = "UCI HAR Dataset"
    dataFile = "uci_har.txt"

    if (!file.exists(dataDir)) {
        download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip",
                      "data.zip", mode = "wb")
        unzip("data.zip")
        file.remove("data.zip")
    }
    
    oldwd <- getwd()
    setwd(dataDir)
    
    temp <- read.table("activity_labels.txt")
    activity_labels <- temp$V2
    
    temp <- read.table("features.txt")
    feature_names <- temp$V2
    
    x_train <- read.table("train/X_train.txt", col.names = feature_names)
    
    y_train <- read.table("train/Y_train.txt", col.names = "Activity")
    y_train$Activity <- factor(y_train$Activity, labels = activity_labels)
    
    subject_train <- read.table("train/subject_train.txt", col.names = "Subject")
    subject_train$Subject <- as.factor(subject_train$Subject)
    
    train <- cbind(subject_train, y_train, x_train)
    

    x_test <- read.table("test/X_test.txt", col.names = feature_names)
    
    y_test <- read.table("test/Y_test.txt", col.names = "Activity")
    y_test$Activity <- factor(y_test$Activity, labels = activity_labels)
    
    subject_test <- read.table("test/subject_test.txt", col.names = "Subject")
    subject_test$Subject <- as.factor(subject_test$Subject)
    
    test <- cbind(subject_test, y_test, x_test)
    
    all <- rbind(train, test)
    
    minstd <- select(all, matches("min|std|Subject|Activity"))
    
    aggr <- aggregate(minstd[, 3:ncol(minstd)],
                      by = list(Subject = minstd$Subject,
                                Activity = minstd$Activity),
                      mean)
    
    write.table(aggr, file = dataFile, row.name = FALSE)
    
    setwd(oldwd)
    
    aggr
}