#------------------------------CISCO Presence API R script-------------------------------------------------------------------------------------------

#Author: Alice Daish adaish@britishmusuem.org
#Date : 03/06/2016
#http://github.com/BritishMuseum/RCiscoPresenceAPI

#Description: R script to facilitate the collection of data from CISCO CMX presence API.  

#What is CISCO Presence Analytics Service? 
#"The Cisco Connected Mobile Experiences (Cisco CMX) Presence Analytics service enables organizations with small deployments, even those with only one or two access points (APs), to use the wireless technology to study customer behavior."
#Reference : http://www.cisco.com/c/en/us/td/docs/wireless/mse/10-2/cmx_config/b_cg_cmx102/the_cisco_cmx_presence_analytics_service.html


#------------------------------------INSTALL PACKAGES-----------------------------------------------------------------------------------------------
#install.packages("httr") #get URL content
library(httr)
#install.packages("jsonlite") #convert file
library(jsonlite)

#------------------------------------Authentication-------------------------------------------------------------------------------------------------
#CMX cisco presence log in credentials
#What is CISCO Presence Analytics Service? http://www.cisco.com/c/en/us/td/docs/wireless/mse/10-2/cmx_config/b_cg_cmx102/the_cisco_cmx_presence_analytics_service.html
#Type in your username and password
user<-"username"
password<-"password"

#----------------------------------TEST YOUR CONNECTION----------------------------------------------------------------------------------------------

#It helps if you have tested the CISCO API calls work for your set up using https://www.getpostman.com/ 
# Your CISCO contact should be able to provide you with a link to the list of API call available - listed below some examples.

#This API call requests todays count for the Wi-Fi presence for a specific siteId
#Change the siteId to your relevant site
test<-GET("https://code.cmxcisco.com/api/presence/v1/connected/count/today?siteId=12345678910",authenticate(user, password))
content(test) #shows the content of the call e.g. count for specific Wi-Fi presence with in a specific site


#-----------------------------------------SITES-------------------------------------------------------------------------------------------------------

#Sites are specific access points in particular rooms or spaces.
#This calls the API and gets a list of sites
sites<-GET("https://code.cmxcisco.com/api/config/v1/sites",authenticate(user, password)) # gets the URL API content including authorization 

#Export formats
str(content(sites)) #see content
sitelist<-content(sites, "text") #collects content as text string
sitelist<-fromJSON(sitelist) #convert to table format from string
head(sitelist) #see the top of the table of sites

#Create a list of site name and siteId
siteId<-cbind(sitelist$aesUidString,sitelist$name)


#---------------------------------------SITES GROUPS--------------------------------------------------------------------------------------------------

#Site groups are a collection of sites created in the CMX portal e.g. collections of rooms on a floor, public vs. private areas
#Data from the Presence cannot be collected at a site group level
sitegroup<-GET("https://code.cmxcisco.com/api/config/v1/sitegroups",authenticate(user, password)) # gets the URL API content including authorization  

#Export formats
str(content(sitegroup)) #see content
siteglist<-content(sitegroup, "text") #collects content as text string
siteglist<-fromJSON(siteglist) #convert to table format from string
head(siteglist) #see the top of the table of site groups

length(siteglist$name) #Number of site you have created
sitegId<-cbind(siteglist$aesUId,siteglist$name) #List of group site name and siteId


#----------------------------COLLECT DAILY VISITOR DATA OF ALL SITES BY HOUR FOR ONE DAY--------------------------------------------------------------
#Use API to collect daily visitor counts for each hour for each site for one day

#Create table
#ncol is the number of columns (stays the same)
length(siteId[,1]) #nrow is the number of sites
hourdata<-matrix(NA,nrow = 97, ncol = 27) #create blank matrix
colnames(hourdata)<-c("SiteID","SiteName","Date","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23") #name columns

#Note: I would have create another for loop to collecting multiple days over this loop but the API stopped/broke too frequently to make this worth constructing. (Future)

#This for loop iterates over all the sites for one day and calls the API for hourly site visitor counts. 
#You need to change the date below to select the specific date of interest
  for (i in 1:length(siteId[,1]))
  { 
      hourdata[i,1]<-as.numeric(siteId[i,1])#Site ID
      hourdata[i,2]<-siteId[i,2] #Site Name
      # Change date in the line
      hourly<-GET(paste0("https://code.cmxcisco.com/api/presence/v1/visitor/hourly?siteId=",siteId[i,1],"&date=2016-06-23"),authenticate(user, password))
      hourdata[i,3]<-"2016-06-23"   # Change date in the line
      #Collecting different times of day from 0 - 23hrs
      hourdata[i,4]<-content(hourly)$`0`
      hourdata[i,5]<-content(hourly)$`1`
      hourdata[i,6]<-content(hourly)$`2`
      hourdata[i,7]<-content(hourly)$`3`
      hourdata[i,8]<-content(hourly)$`4`
      hourdata[i,9]<-content(hourly)$`5`
      hourdata[i,10]<-content(hourly)$`6`
      hourdata[i,11]<-content(hourly)$`7`
      hourdata[i,12]<-content(hourly)$`8`
      hourdata[i,13]<-content(hourly)$`9`
      hourdata[i,14]<-content(hourly)$`10`
      hourdata[i,15]<-content(hourly)$`11`
      hourdata[i,16]<-content(hourly)$`12`
      hourdata[i,17]<-content(hourly)$`13`
      hourdata[i,18]<-content(hourly)$`14`
      hourdata[i,19]<-content(hourly)$`15`
      hourdata[i,20]<-content(hourly)$`16`
      hourdata[i,21]<-content(hourly)$`17`
      hourdata[i,22]<-content(hourly)$`18`
      hourdata[i,23]<-content(hourly)$`19`
      hourdata[i,24]<-content(hourly)$`20`
      hourdata[i,25]<-content(hourly)$`21`
      hourdata[i,26]<-content(hourly)$`22`
      hourdata[i,27]<-content(hourly)$`23`      
  }

#View the data
Views(hourdata)

#Save
write.csv(hourdata,"hourvisitor20160623.csv",row.names=FALSE)


#----------------------------------------AVERAGE DWELL TIME DATA OF ALL SITES FOR ONE DAY -----------------------------------------------------------

#Use API to collect average dwell time for each site for one day

#Create table
#ncol is the number of columns (stays the same)
length(siteId[,1]) #nrow is the number of sites
dwellAverage<-matrix(NA,nrow = 97, ncol =4) #create blank matrix
colnames(dwellAverage)<-c("SiteID","SiteName","Date","DwellTime_Minutes") #name columns


#This for loop iterates over all the sites for one day and calls the API for visitor per dwell level for one day. 
#You need to change the date below to select the specific date of interest
for (i in 1:length(siteId[,1]))
{ 
  dwellAverage[i,1]<-as.numeric(siteId[i,1]) #Site ID
  dwellAverage[i,2]<-siteId[i,2] #Site Name
  # Change date in the line
  dwell<-GET(paste0("https://code.cmxcisco.com/api/presence/v1/dwell/average?siteId=",siteId[i,1],"&startDate=2016-05-18&endDate=2016-05-18"),authenticate(user, password))
  dwellAverage[i,3]<-"2016-05-18" # Change date in the line
  #Collecting average dwell time of visitors for each site
  dwellAverage[i,4]<-content(dwell)
}

#View the data
Views(dwellAverage)

#Save
write.csv(dwellAverage,"dwellvisitor20160518.csv",row.names=FALSE)


#----------------------------------------DWELL TIME LEVEL BY SITE FOR ONE DAY------------------------------------------------------------------------

#Use API to collect dwell time level for each site for one day

#Create table
#ncol is the number of columns (stays the same)
length(siteId[,1]) #nrow is the number of sites
dwellAverageLevel<-matrix(NA,nrow = 97, ncol =8) #create blank matrix
colnames(dwellAverageLevel)<-c("SiteID","SiteName","Date","FIVE_TO_THIRTY_MINUTES","THIRTY_TO_SIXTY_MINUTES","ONE_TO_FIVE_HOURS","FIVE_TO_EIGHT_HOURS","EIGHT_PLUS_HOURS") #name columns
 

#This for loop iterates over all the sites for one day and calls the API for visitor per dwell level for one day. 
#You need to change the date below to select the specific date of interest
 for (i in 1:length(siteId[,1]))
 { 
  dwellAverageLevel[i,1]<-as.numeric(siteId[i,1]) #Site ID
  dwellAverageLevel[i,2]<-siteId[i,2] #Site Name
  # Change date in the line
  dwellLevel<-GET(paste0("https://code.cmxcisco.com/api/presence/v1/dwell/count?siteId=",siteId[i,1],"&date=2016-05-30"),authenticate(user, password))
  dwellAverageLevel[i,3]<-"2016-05-30" # Change date in the line
  #Collecting visitors in each dwell levels for each site
  dwellAverageLevel[i,4]<-content(dwellLevel)$`FIVE_TO_THIRTY_MINUTES`
  dwellAverageLevel[i,5]<-content(dwellLevel)$`THIRTY_TO_SIXTY_MINUTES`
  dwellAverageLevel[i,6]<-content(dwellLevel)$`ONE_TO_FIVE_HOURS`
  dwellAverageLevel[i,7]<-content(dwellLevel)$`FIVE_TO_EIGHT_HOURS`
  dwellAverageLevel[i,8]<-content(dwellLevel)$`EIGHT_PLUS_HOURS`
 }

#View the data
Views(dwellAverageLevel)

#Save
write.csv(dwellAverageLevel,"dwellvisitorlevel20160530.csv",row.names=FALSE)


#----------------------------------AVERAGE DWELL TIME BETWEEN TWO DATES FOR ALL SITES --------------------------------------------------------------

#Use API to collect average dwell time between two dates for all sites
#Useful for understanding average dwell per week or per month for each site

#Create table
#ncol is the number of columns (stays the same)
length(siteId[,1]) #nrow is the number of sites
dwellAverage7<-data.frame(matrix(NA,nrow = 97, ncol =4)) #create blank matrix
colnames(dwellAverage7)<-c("SiteID","SiteName","Date","AverageDwellTime") #name columns


#This for loop iterates over all the sites between two dates and calls the API for average dwell time over that time period. 
#You need to change the date below to select the specific date of interest
for (i in 1:length(siteId[,1]))
{ 
  dwellAverage7[i,1]<-as.numeric(siteId[i,1]) #Site ID
  dwellAverage7[i,2]<-siteId[i,2] #Site Name
  #This API returns the average visitor dwell time between two dates by Site
  dwell<-GET(paste0("https://code.cmxcisco.com/api/presence/v1/dwell/average?siteId=",siteId[i,1],"&startDate=2016-05-14&endDate=2016-05-20"),authenticate(user, password))
  dwellAverage7[i,3]<-"2016-05-14_2016-05-20" # Change dates in the line
  #Collecting average visitors dwell time for each site
  dwellAverage7[i,4]<-content(dwell)
}

#View the data
Views(dwellAverage7)

#Save
write.csv(dwellAverage7,"dwellaverage7days.csv",row.names=FALSE)

#---------------------------------------------------END----------------------------------------------------------------------------------------------
