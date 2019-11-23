library(dplyr)
library(lubridate)
# set the working directory
setwd("C:/Users/askal/OneDrive/Desktop/GTechNotes/fall2019/DVA/project/houston_311/data/data")

# read the final merged files
df1 <- read.delim("Houston311_storm_rec_police_traffic2017.csv",header=TRUE,sep=";")
df2 <- read.delim("Houston311_storm_rec_police_traffic2018.csv",header=TRUE,sep=";")
df3 <- read.delim("Houston311_storm_rec_police_traffic2019.csv",header=TRUE,sep=";")

# save open ticket records into a dataframe
f1 <- df1[df1$DATE.CLOSED=="",]
f2 <- df2[df2$DATE.CLOSED=="",]
f3 <- df3[df3$DATE.CLOSED=="",]
open_tickets <- rbind(f1,f2,f3)
nrow(open_tickets)

# remove EMPTY DATE.CLOSED rows for each year from data
df1 <- df1[df1$DATE.CLOSED!="",]
df2 <- df2[df2$DATE.CLOSED!="",]
df3 <- df3[df3$DATE.CLOSED!="",]

# for each year, change DATE.CLOSED and SR.CREATE.DATE to same date-time format
df1$DATE.CLOSED <- (force_tz(as.POSIXct(df1$DATE.CLOSED),tz = "UTC"))
df2$DATE.CLOSED <- (force_tz(as.POSIXct(df2$DATE.CLOSED,format='%m/%d/%Y %H:%M'),tz = "UTC"))
df3$DATE.CLOSED <- (force_tz(as.POSIXct(df3$DATE.CLOSED),tz = "UTC"))

df1$SR.CREATE.DATE <- (force_tz(as.POSIXct(df1$SR.CREATE.DATE),tz = "UTC"))
df2$SR.CREATE.DATE <- (force_tz(as.POSIXct(df2$SR.CREATE.DATE),tz = "UTC"))
df3$SR.CREATE.DATE <- (force_tz(as.POSIXct(df3$SR.CREATE.DATE),tz = "UTC"))
open_tickets$SR.CREATE.DATE <- (force_tz(as.POSIXct(open_tickets$SR.CREATE.DATE),tz = "UTC"))

# add additional column CLOSED.WITHIN
df1$CLOSED.WITHIN <- 0
df2$CLOSED.WITHIN <- 0
df3$CLOSED.WITHIN <- 0
CLOSED.WITHIN <- df1$DATE.CLOSED - df1$SR.CREATE.DATE
CLOSED.WITHIN <- as.numeric(CLOSED.WITHIN)
CLOSED.WITHIN <- CLOSED.WITHIN/(24*60*60)
CLOSED.WITHIN <- round(CLOSED.WITHIN,4)
df1$CLOSED.WITHIN <- CLOSED.WITHIN

CLOSED.WITHIN <- df2$DATE.CLOSED - df2$SR.CREATE.DATE
CLOSED.WITHIN <- as.numeric(CLOSED.WITHIN)
CLOSED.WITHIN <- CLOSED.WITHIN/(24*60*60)
CLOSED.WITHIN <- round(CLOSED.WITHIN,4)
df2$CLOSED.WITHIN <- CLOSED.WITHIN

CLOSED.WITHIN <- df3$DATE.CLOSED - df3$SR.CREATE.DATE
CLOSED.WITHIN <- as.numeric(CLOSED.WITHIN)
CLOSED.WITHIN <- CLOSED.WITHIN/(24*60*60)
CLOSED.WITHIN <- round(CLOSED.WITHIN,4)
df3$CLOSED.WITHIN <- CLOSED.WITHIN

# merge the 2017-2019 data into one dataframe with all rows and columns 
totaldf <- rbind(df1,df2,df3)

# CLOSED.WITHIN buckets
totaldf$CLOSED.WITHIN.BIN <- 0
totaldf[totaldf$CLOSED.WITHIN<=0.7098,]$CLOSED.WITHIN.BIN <- "bin 0-0.7098"
totaldf[(totaldf$CLOSED.WITHIN>0.7098) & (totaldf$CLOSED.WITHIN<=3.3299),]$CLOSED.WITHIN.BIN <- "bin 0.7099-3.3299"
totaldf[(totaldf$CLOSED.WITHIN>3.3299) & (totaldf$CLOSED.WITHIN<=12.8854),]$CLOSED.WITHIN.BIN <- "bin 3.3300-12.8854"
totaldf[(totaldf$CLOSED.WITHIN>12.8854) & (totaldf$CLOSED.WITHIN<=944.2400),]$CLOSED.WITHIN.BIN <- "bin 12.8855-944.2400"

open_tickets$CLOSED.WITHIN <- ""
open_tickets$CLOSED.WITHIN.BIN <- "N/A"

# merge totaldf with open tickets dataframe
totaldf$DATE.CLOSED <- as.character(totaldf$DATE.CLOSED)
open_tickets$DATE.CLOSED <- as.character(open_tickets$DATE.CLOSED)
totaldf <- rbind(totaldf,open_tickets)

# change "" district to "unknown"
totaldf$DISTRICT <- as.character(totaldf$DISTRICT)
unique(totaldf$DISTRICT)
totaldf[totaldf$DISTRICT=="",]$DISTRICT <- "unknown"
unique(totaldf$DISTRICT)

# remove department "test"
totaldf$DEPARTMENT <- as.character(totaldf$DEPARTMENT)
unique(totaldf$DEPARTMENT)
totaldf <- totaldf[totaldf$DEPARTMENT!="Test",]
unique(totaldf$DEPARTMENT)
nrow(totaldf)

# write the consolidated data with all rows and columns into a csv file
write.table(totaldf,file="Merged_Houston311_storm_rec_police_traffic_v2.txt",row.names=F,sep='|',quote=FALSE)


