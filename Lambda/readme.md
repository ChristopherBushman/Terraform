## Lambda Functions
#Purpose:
These two lambda functions start and stop the EC2 servers at the given times that they are set up with in AWS.  There are a few key parts in these functions that must be changed to fit the purposes of your EC2 functional basis. 
- **Region**:  This is the region that the lambda function will take effect in.  It's recommended to go to your EC2 panel and check what region the EC2's you wish to be effected are running in.
- **instances**: This array shows all the EC2 instances that will be effected.  This must be changed to your EC2 instance ID's which can be found on the EC2 dashboard for the region you've selected.

## Cron Paramaters
#Scheduling Paramaters for the rules that 'Start' and 'Stop' the EC2 instances.
-**Start: 0 0 ? * 6 * (Every Friday at 00:00:00 GMT)
-**Stop: 0 0 ? * 2 * (Every Monday at 00:00:00 GMT)
