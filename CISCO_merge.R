#------------------------------CISCO Presence API : Combine daily table requests--------------------------------------------------------------

#Author: Alice Daish adaish@britishmusuem.org
#Date : 03/06/2016
#http://github.com/BritishMuseum/RCiscoPresenceAPI

#Description: R script to combine multiple daily tables of CISCO presence data.  

#What is CISCO Presence Analytics Service? 
#"The Cisco Connected Mobile Experiences (Cisco CMX) Presence Analytics service enables organizations with small deployments, even those with only one or two access points (APs), to use the wireless technology to study customer behavior."
#Reference : http://www.cisco.com/c/en/us/td/docs/wireless/mse/10-2/cmx_config/b_cg_cmx102/the_cisco_cmx_presence_analytics_service.html


#-------------------------------------- COMBINE VISITOR COUNT ---------------------------------------------------------------------------------
#install.packages("lubridate") #date maniuplation
library(lubridate)
#install.packages("dplyr") #wrangling
library(dplyr)

#This is a bit of a hack around (apologies) as I couldn't get whole months of data. These are specific date iterations for may and june

# MAY DATA EXAMPLE
number1<-c(14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31) # May date
data1<-c() #empty
#For loop to combine all the named hour visitor data 
#Making sure the same date naming is used as below for the csv files of data exported using "RCiscoPresenceApi.R"
for (i in 1:length(number1))
{
  data1<-rbind(data1,read.csv(paste0("hourvisitor201605",number1[i],".csv"),header=T))
}

# JUNE DATA EXAMPLE
number2<-c("01","02","03","04","05","06","07","08","09",10,11,12,13,14,15,16,17,18,19,20,21,22) # June date
data2<-c() #empty
#For loop to combine all the named hour visitor data 
#Making sure the same date naming is used as below for the csv files of data exported using "RCiscoPresenceApi.R"
for (i in 1:length(number2))
{
  data2<-rbind(data2,read.csv("hourvisitor201606",number2[i],".csv"),header=T))
}

#-----------Merge Months --------------------------------------------------------------------------------------------------------------------
#Checking the size of the data
dim(data1) 
dim(data2) 

#Merge may and june data together 
data<-rbind(data1,data2)

#------------------------
#View combined month data
Views(data) 

#Save combined date
write.csv(data,"hourvisitortogether.csv",row.names=FALSE) 


#-------------------------------------------------END----------------------------------------------------------------------------------------