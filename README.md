# R code to collect Wi-Fi data from CISCO Presence API  :iphone::wrench::chart_with_upwards_trend:

![](https://img.shields.io/badge/repo-british-museum-r-cisco-presence-api-red.svg) ![](https://img.shields.io/badge/code-R-blue.svg) [![DOI](https://zenodo.org/badge/71580641.svg)](https://zenodo.org/badge/latestdoi/71580641)

**OBJECTIVE: R script to collect Wi-Fi presence data from CISCO presence API**

*What is CISCO Presence Analytics Service?*

*"The Cisco Connected Mobile Experiences (Cisco CMX) Presence Analytics service enables organizations with small deployments, even those with only one or two access points (APs), to use the wireless technology to study customer behavior."*

Reference : [CISCO CMX presence analytics](http://www.cisco.com/c/en/us/td/docs/wireless/mse/10-2/cmx_config/b_cg_cmx102/the_cisco_cmx_presence_analytics_service.html)

---
## R Code
:wrench: Two code parts : One to collect the data and the other to merge the single data files into one table. 

# [PresenceAPIcalls](https://github.com/BritishMuseum/british-museum-r-cisco-presence-api/blob/master/PresenceAPIcalls.R)
Description: R script to facilitate the collection of data from CISCO CMX presence API.  
* Connect to Presence API
* Find list of sites
* Find list of sites groups
* Visitors by Hour by day
* Average dwell time by site by day
* Dwell time level by site by day
* Average dwell time between two dates by site

# [CISCO_merge](https://github.com/BritishMuseum/british-museum-r-cisco-presence-api/blob/master/CISCO_merge.R)
* Collects individual data files and merges in one table

---

*Prerequisites : Download [R](https://www.r-project.org/) and [R studio desktop](https://www.rstudio.com/products/rstudio/download/) to get started.*

The British Museum tested CISCO presence but it is not in use.
