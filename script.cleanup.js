///////////////////////////
// Mongojs Script to clean measureValues collection
// cleans the last 3 weeks (21 days before) and keeps only the last week
// This script runs from job.sh , which in turn is executed from cronjob at end of each month
use openhab;

var date = new Date();
date.setDate(22);
var targetDate = date.toISOString();
db.measurevalues.remove({"createdAt_measureValue" : { $lt : new ISODate(targetDate) }});
