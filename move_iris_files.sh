#!/bin/bash
#-------------------------------------------------->#
#File scp/ftp copy script , version 1.0
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

if test "$#" -ne 3; then
    echo -e "\nPlease call '$0 copy <PRIMARY_FOLDER> <FTP_HOST>' to run this command!\n"
    echo "Cache source and Target instance is required"
    exit 1
fi

export EPIC_HOME=/epic
export epicadm_home=~epicadm
####export MAILGRP=Cachealerts@thp.ca
#####export MAILGRP=asif.jafri@thp.ca
export LOGFILE=$epicadm_home/script/log/copy_file-$1-$(date +%Y%m%d_%H%M).log
touch $LOGFILE

# define primary/source info

PRIMARY_FOLDER=$2
FTP_HOST=$3
## uhtmpintStorage

# hide SSH warning message about permanently adding to known hosts
#(ssh $PRIMARY_HOST "/bin/true") > /dev/null 2>&1
#if [ $? -gt 0 ]
 # then
  #  echo "Error : Cannot access SOURCE $PRIMARY_HOST" |tee  $LOGFILE
   # ExitEmail
   # exit 20
#fi

echo "Beginning file transfer...from $PRIMARY_FOLDER to $FTP_HOST" 
echo "\tChecking for files ..." $i
for i in $(ls /epicfiles/nonprdfiles/misc/$PRIMARY_FOLDER/outgoing/); do
        echo "File found .......$i"
##        (scp -pr $PRIMARY_HOST:/epic/$PRIMARY_INST/$i /epic/$ASYNC_INST/) > /dev/null
##          (cp -pr /epic/$PRIMARY_INST/$i /epic/$ASYNC_INST/) >> $LOGFILE
done
exit $?

