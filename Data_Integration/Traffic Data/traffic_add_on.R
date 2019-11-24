library(dplyr)
library(ggplot2)
library(parallel)

df17=read.csv("Merged_Houston311_Storm_rec_PoliceDistance_2017.csv")
df18=read.csv("Merged_Houston311_Storm_rec_PoliceDistance_2018.csv")
df19=read.csv("Merged_Houston311_Storm_rec_PoliceDistance_2019.csv")
              
traffic<-read.csv("traffic_data/TrafficCounts_OpenData_wm.csv")
cores=detectCores()-2
adt_vector<-function(x,y){
  l=((as.numeric(x)-traffic$POINT_Y)^2 + (as.numeric(y)-traffic$POINT_X)^2)^0.5
  mins=which(l==min(l))
  
  if (length(mins)>1){
    m_check=-1
    for (m in mins) {
      print("m in mins")
      print(m)
      if(m_check<traffic$ADT[m]){
        m_check<-traffic$ADT[m]}
    }
    return(m_check)
  } else{
    return(traffic$ADT[mins])
  }
}

ptm <- proc.time()
final_adt18<-mcmapply( adt_vector,df18$LATITUDE, df18$LONGITUDE, mc.cores=cores)
proc.time() - ptm


ptm <- proc.time()
final_adt17<-mcmapply( adt_vector,df17$LATITUDE, df17$LONGITUDE, mc.cores=cores)
proc.time() - ptm


ptm <- proc.time()
final_adt19<-mcmapply( adt_vector,df19$LATITUDE, df19$LONGITUDE, mc.cores=cores)
proc.time() - ptm

df17$Traffic<-final_adt17
df18$Traffic<-final_adt18
df19$Traffic<-final_adt19

write_csv2(df17, "Houston311_storm_rec_police_traffic2017.csv")
write_csv2(df18, "Houston311_storm_rec_police_traffic2018.csv")
write_csv2(df19, "Houston311_storm_rec_police_traffic2019.csv")