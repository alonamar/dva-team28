############# DEFINE PACAKAGE  ###########################################
install.packages("tidyverse")
install.packages("dplyr")
install.packages("data.table")
install.packages("ggplot2")
library(data.table)
library(dplyr)
library(ggplot2)

############## READ DATA #################################################
policedata = read.csv("Hou2017Cleaned.csv",header=T)
colnames(policedata)

############## SELECT COLUMNS REQUIRED ###################################
newdata <- policedata[c(1,3,13,14,16,20,30)]
colnames(newdata)

############## EXTRACT DATE FROM THE COLUMN ##############################
head(newdata$SR_CREATE_DATE) # 2017-01-07 08:32:27.000

############## ADD CATEGORICAL COLUMN ####################################
newdata$polstdis<-sapply(newdata$disnearestpolst, function(x) 
  if (x <= 2) "under 2km"
  else if (x > 2) "over 2km")

############## GROUPBY SR TYPE ###########################################
newdata_group <- group_by(newdata,SR_TYPE)
head(newdata_group)

############## FILTER DATA ###############################################
data_filter <- filter(newdata_group, SR_TYPE =="Nuisance On Property") 
data_filter

data_filter1 <- filter(data_filter, polstdis == "over 2km")
data_filter1

data_filter2 <- filter(data_filter, polstdis == "under 2km")
data_filter2

############# BAR PLOT ###################################################
counts <- table(data_filter$polstdis == "over 2km", data_filter$polstdis == "under 2km")
barplot(counts, main="Nuisance on Property by Police Station Under 2km and over 2km",
        xlab="Number of 311 calls to report Nuisance on Property", col=c("darkblue","red"),
        names.arg=c("over 2km", "under 2km"))


