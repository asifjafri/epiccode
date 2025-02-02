#!/bin/bash
#-------------------------------------------------->#
# Env copy script , version 1.0
# Author Asif Jafri
#  Warning:
#  -------
#  Scrpt runs as epicadm
#  $copy_env.sh <source env> <target env>
#  This script uses the following epic standards
#-> File system for SS <env>01ss eg : exam01ss
#-> NOTE : This script only uses mcvhepicodb90 as SOURCE server. <---
#-------------------------------------------------->#
#
ExitEmail()
{
tail -5 $LOGFILE  | mail -s "--ERROR-- envcopy.sh $PRIMARY_INST -->  $ASYNC_INST  report for $(date +%Y%m%d_%H%M%S)" -a $LOGFILE $MAILGRP
}

#--Main script starts from here

if test "$#" -ne 2; then
    echo -e "\nPlease call '$0 <Source> <Target>' to run this command!\n"
    echo "Cache source and Target instance is required"
    exit 1
fi

export EPIC_HOME=/epic
export INSTANCE_HOME=$EPIC_HOME/$2
####export MAILGRP=Cachealerts@thp.ca
#####export MAILGRP=asif.jafri@thp.ca
tdate=$(date +%Y%m%d)
efolder="/odba/dbfiles/ss_restore/$tdate"
mkdir -p $efolder
export LOGFILE=$efolder/restoreSnaphot-$1-$(date +%Y%m%d_%H%M).log
touch $LOGFILE

# define primary/source info
PRIMARY_HOST=CEPICODB01T
PRIMARY_INST=$101ss
# Define target info
ASYNC_INST=$201

# hide SSH warning message about permanently adding to known hosts
#(ssh $PRIMARY_HOST "/bin/true") > /dev/null 2>&1
#if [ $? -gt 0 ]
 # then
  #  echo "Error : Cannot access SOURCE $PRIMARY_HOST" |tee  $LOGFILE
   # ExitEmail
   # exit 20
#fi

# pull CACHE.DATs from primary
# Check primary instance if needed###  (ssh mcvhepicodb90 "getenv")|grep  "^$upenv"|grep "running"

upenv=`echo $2 | tr '[:lower:]' '[:upper:]'`
iris qlist | grep "^$upenv"|grep "down"
if [ $? -gt 0 ]
 then
    echo "Error :   Cannot verify status for Environment $2 as down. Cannot continue copy_env.sh" |tee $LOGFILE
    ExitEmail
    exit 22
fi

echo "Beginning file transfer...from $PRIMARY_INST to $ASYNC_INST" >> $LOGFILE
for i in $(ls /epic/$PRIMARY_INST/); do
        echo "\tCopying ..." $i >> $LOGFILE
##        (scp -pr $PRIMARY_HOST:/epic/$PRIMARY_INST/$i /epic/$ASYNC_INST/) > /dev/null
          (cp -pr /epic/$PRIMARY_INST/$i /epic/$ASYNC_INST/) >> $LOGFILE
done
exit $?

