#!/bin/bash
TIMESTAMP=`/bin/date +"%Y%m%dT%H%M%S"`
BACKUP_NAME=${TIMESTAMP}.mongodump.gz
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Initiate backup => " $current_date

if mongodump --quiet -h 127.0.0.1:27017 -d openhab -u admin -p moss22124113 --authenticationDatabase "admin" --gzip --archive=/home/ubuntu/backup/${BACKUP_NAME} \
 && aws s3 cp /home/ubuntu/backup/${BACKUP_NAME} "s3://mongobd-beeta-backend-bucket-s3" && rm /home/ubuntu/backup/${BACKUP_NAME} ;then
    echo "OK => Backup succeeded"
    echo "Initiate Db Cleanup"
    mongo --port 27017 -u "admin" -p "moss22124113" --authenticationDatabase "admin" < /home/ubuntu/backup/script.clean-measures.js
    echo "OK => Db Cleanup finished"
else
    echo "KO => Backup failed"
fi
echo "Cronjob finished"
echo "Moss Says Hello ;)"

# This is crontab -e settings you must have in your cron
# For this job to run at the end of each month
# 55 23 30 4,6,9,11 * /home/ubuntu/backup/job.sh >> /home/ubuntu/backup/cron.log 2>&1
# 55 23 31 1,3,5,7,8,10,12 * /home/ubuntu/backup/job.sh >> /home/ubuntu/backup/cron.log 2>&1
# 55 23 28 2 * /home/ubuntu/backup/job.sh >> /home/ubuntu/backup/cron.log 2>&1

