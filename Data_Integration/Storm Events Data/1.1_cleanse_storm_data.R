# Set working directory
setwd("C:/Users/askal/OneDrive/Desktop/GTechNotes/fall2019/DVA/project/houston_311/raw_data")

# Load Storm Data - this code currently cleans 2018 storm data
# For the other years, uncomment each year individually and run the code again

# 2017 data
# df2 <- read.delim("storm_data/StormEvents_details-ftp_v1.0_d2017_c20190817.csv",header=TRUE,sep=",")

# 2018 data
df2 <- read.delim("storm_data/StormEvents_details-ftp_v1.0_d2018_c20191016.csv",header=TRUE,sep=",")

# 2019 data
# df2 <- read.delim("storm_data/StormEvents_details-ftp_v1.0_d2019_c20191016.csv",header=TRUE,sep=",")

# Filter based on Texas State
df2_texas <- df2[df2$STATE == "TEXAS",]
unique(df2_texas$STATE)
df2_texas$STATE <- as.character(df2_texas$STATE)

#filter storm data based on COUNTY
unique(df2_texas$CZ_NAME)
df2_texas <- df2_texas[df2_texas$CZ_NAME == "HARRIS",]
df2_texas$CZ_NAME <- as.character(df2_texas$CZ_NAME)

# remove Duplicate Data from Storm Data - directly remove duplicates based on certain columns
nrow(df2_texas)
nrow(df2_texas[!duplicated(df2_texas),])
# consider just certain columns and check for duplicates
nrow(df2_texas[,c("CZ_NAME","BEGIN_DATE_TIME","END_DATE_TIME","EVENT_TYPE")])
nrow(df2_texas[!duplicated(df2_texas[,c("CZ_NAME","BEGIN_DATE_TIME","END_DATE_TIME","EVENT_TYPE")]),])

#create new dataset without duplicates
unique_weather_data<- df2_texas[!duplicated(df2_texas[,c("BEGIN_DATE_TIME","END_DATE_TIME","EVENT_TYPE")]),]

# remove further duplicates by considering just Date but not Time and ignore the event type
nrow(unique_weather_data[!duplicated(unique_weather_data[,c("BEGIN_YEARMONTH","BEGIN_DAY","END_YEARMONTH","END_DAY","EVENT_TYPE")]),])
unique_weather_data <- unique_weather_data[!duplicated(unique_weather_data[,c("BEGIN_YEARMONTH","BEGIN_DAY","END_YEARMONTH","END_DAY","EVENT_TYPE")]),]

# Save Cleaned storm data

# 2017 cleaned storm data
# write.csv(unique_weather_data,file="cleaned_storm_data/StormEvents_details_2017_cleansed.csv",row.names=F)

# 2018 cleaned storm data
write.csv(unique_weather_data,file="cleaned_storm_data/StormEvents_details_2018_cleansed.csv",row.names=F)

# 2019 cleaned storm data
# write.csv(unique_weather_data,file="cleaned_storm_data/StormEvents_details_2019_cleansed.csv",row.names=F)
