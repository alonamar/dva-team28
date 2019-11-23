# set working directory
setwd("C:/Users/askal/OneDrive/Desktop/GTechNotes/fall2019/DVA/project/houston_311/raw_data")

# This code currently merges 2018 data  
# for other years, uncomment each year individually and run separately

# Load Houston 311 Data
# Load 2018
df <- read.delim("new_houston/311-Public-Data-Extract-2018-clean-HARRIS.csv",header=TRUE,sep=",")

# Load 2017
# df <- read.delim("new_houston/Hou2017Cleaneddatawithpolicedata_headers.csv",header=TRUE,sep=",")
# colnames(df) <- c("CASE.NUMBER","SR.LOCATION","COUNTY","DISTRICT","NEIGHBORHOOD","TAX.ID","TRASH.QUAD","RECYCLE.QUAD","TRASH.DAY","HEAVY.TRASH DAY","RECYCLE.DAY","KEY.MAP","MANAGEMENT.DISTRICT","DEPARTMENT","DIVISION","SR.TYPE","QUEUE","SLA","STATUS","SR.CREATE.DATE","DUE.DATE","DATE.CLOSED","OVERDUE","Title","x","y","LATITUDE","LONGITUDE","Channel.Type")

# Load 2019
# df <- read.delim("new_houston/311-Public-Data-Extract-2019-clean.csv",header=TRUE,sep=",")

# Extract distinct counties and clean the county data 
df$COUNTY <- as.character(df$COUNTY)
unique(df$COUNTY)
df$COUNTY[df$COUNTY == "Harris County"] <- "HARRIS"
nrow(df)

# Load Cleansed Storm Data
# Load 2018 storm data
df2 <- read.delim("cleaned_storm_data/StormEvents_details_2018_cleansed.csv",header=TRUE,sep=",")

# Load 2017 storm data
# df2 <- read.delim("cleaned_storm_data/StormEvents_details_2017_cleansed.csv",header=TRUE,sep=",")

# Load 2019 storm data
# df2 <- read.delim("cleaned_storm_data/StormEvents_details_2019_cleansed.csv",header=TRUE,sep=",")

# Modify begindatetime and enddatetime columns to remove the time part in storm data
df2$BEGIN_DATE_TIME <- as.Date(df2$BEGIN_DATE_TIME,format='%d-%b-%y %H:%M:%S')
df2$END_DATE_TIME <- as.Date(df2$END_DATE_TIME,format='%d-%b-%y %H:%M:%S')

# 2018: Modify the 311 data and remove time from the sr create date and date closed columns
df$srstartdate <- as.Date(df$SR.CREATE.DATE,format='%m/%d/%Y %H:%M')
df$srenddate <- as.Date(df$DATE.CLOSED,format='%m/%d/%Y %H:%M')

# 2017: Modify the 311 data and remove time from the sr create date and date closed columns
#df$srstartdate <- as.Date(df$SR_CREATE_DATE,format='%Y-%m-%d %H:%M:%OS')
#df$srenddate <- as.Date(df$DATE_CLOSED,format='%Y-%m-%d %H:%M:%S')

# 2019: Modify the 311 data and remove time from the sr create date and date closed columns
# Modify the 311 data and remove time from the sr create date and date closed columns
# df$srstartdate <- as.Date(df$SR.CREATE.DATE,format='%Y-%m-%d %H:%M:%S')
# df$srenddate <- as.Date(df$DATE.CLOSED,format='%Y-%m-%d %H:%M:%S')

# Append weather flag column [1:event,0:no_event] (considering only new tickets)
df$weatherflag <- 0
df$eventType <- ""

for (row in 1:nrow(df)){
  startdate <- df[row,"srstartdate"]
    for (row2 in 1:nrow(df2)){
      eventstartdate <- df2[row2,"BEGIN_DATE_TIME"]
      eventenddate <- df2[row2,"END_DATE_TIME"]
      if(startdate>=eventstartdate && startdate<=eventenddate){
        df$weatherflag[row] <- 1
        if(!grepl(df2[row2,"EVENT_TYPE"],df$eventType[row],fixed=T)){
        df$eventType[row] <- trimws(paste(df$eventType[row],df2[row2,"EVENT_TYPE"]))
        }
      }
    }
}


# Save data with weather flag and eventtype details
# Save 2018
df_final <- df[,-(30:31)]
write.csv(df_final,file="cleaned_storm_data/Merged_Houston311_Storm_2018.csv",row.names=F)
# Save 2017
# df_final <- df[,-(31:32)]
# write.csv(df_final,file="cleaned_storm_data/Merged_Houston311_Police_Storm_2017.csv",row.names=F)
# Save 2019
# df_final <- df[,-(30:33)]
# write.csv(df_final,file="cleaned_storm_data/Merged_Houston311_Storm_2019.csv",row.names=F)




