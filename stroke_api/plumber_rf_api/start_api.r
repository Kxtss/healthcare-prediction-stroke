# 1. Load the Plumber library
library(plumber)

# 2. Set the working directory to the location of plumber.R (CRUCIAL!)
# Replace 'your_user'
setwd("C:/Users/ktss/Desktop/healthcare-prediction-stroke")

# 3. Start the API by reading the plumber.R file
# The console will LOCK, indicating that the service is running.
pr <- pr("plumber.R")
pr_run(pr)