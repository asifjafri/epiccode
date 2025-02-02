#!/bin/bash
#-------------------------------------------------->#
# Snap copy script , version 1.0
# Author Asif Jafri
#  Warning:
#  -------
#  Scrpt runs as root
#  create_ss.ksh <env>
#-------------------------------------------------->#
#
ExitEmail()
{
tail -5 $LOGFILE  | mail -s "--ERROR-- create_ss.ksh $PRIMARY_INST  report for $(date +%Y%m%d_%H%M%S)" -a $LOGFILE $MAILGRP
}

#--Main script starts from here

if test "$#" -ne 1; then
    echo -e "\nPlease call '$0  <Target>' to run this command!\n"
    echo "Iris Target instance is required"
    exit 1
fi

export PRIMARY_INST=$1
export EPIC_HOME=/epic
export INSTANCE_HOME=$EPIC_HOME/$PRIMARY_INST
export MAILGRP="Asif.Jafri@unityhealth.to,sam.youssef@unityhealth.to"
tdate=$(date +%Y%m%d)
efolder="/home/epicadm/scripts/ss_backup/"
mkdir -p $efolder
export LOGFILE=$efolder/backupSnaphot-$1-$(date +%Y%m%d_%H%M).log


#####Step 0  Umount the snapshot file system
echo "umount  /epic/${PRIMARY_INST}01ss" |tee -a  $LOGFILE
umount  /epic/${PRIMARY_INST}01ss


if [ $? -gt 0 ]
  then
    echo "Error : Cannot Umount /epic/${PRIMARY_INST}01ss" |tee -a  $LOGFILE
    echo "Maybe it is the first time. Ignoring it"|tee -a  $LOGFILE
fi

####Step 0.1 Remove exisitng snapshot
echo "/usr/sbin/lvremove -f /dev/mapper/${PRIMARY_INST}vg-${PRIMARY_INST}01ss"|tee -a  $LOGFILE
/usr/sbin/lvremove -f /dev/mapper/${PRIMARY_INST}vg-${PRIMARY_INST}01ss>>  $LOGFILE

if [ $? -gt 0 ]
  then
    echo "Error : Cannot remove /dev/${PRIMARY_INST}vg/${PRIMARY_INST}01ss snpashot" |tee -a  $LOGFILE
    echo "Maybe it is the first time. Ignoring it"|tee -a  $LOGFILE
fi

#Insstfreeze


###Step 1 : Freeze Instance

echo "Freezing the instance $INSTANCE_HOME"
${INSTANCE_HOME}/bin/instfreeze>> $LOGFILE

if [ $? -gt 0 ]
  then
    echo "Error : Cannot freeze $PRIMARY_INST" |tee -a  $LOGFILE
    ExitEmail
  exit 20
fi
#Step 2 : create snapshot
#Create snapshot 
echo "/usr/sbin/lvcreate --snapshot --size 5G  --name ${PRIMARY_INST}01ss /dev/mapper/${PRIMARY_INST}vg-epic${PRIMARY_INST}01_lv"|tee -a $LOGFILE
/usr/sbin/lvcreate --snapshot --size 5G --name ${PRIMARY_INST}01ss /dev/mapper/${PRIMARY_INST}vg-epic${PRIMARY_INST}01_lv>>$LOGFILE
if [ $? -gt 0 ]
  then
    echo "Error : Cannot create snapshot $PRIMARY_INSTANCE" |tee -a  $LOGFILE
    ${INSTANCE_HOME}/bin/instthaw >>  $LOGFILE
    ${INSTANCE_HOME}/bin/runlevel -l >>  $LOGFILE
    ExitEmail
  exit 20
fi

#Step 3: UnFreeze Instance
echo "Un-FrFrezing the instance $PRIMARY_INSTANCE"
${INSTANCE_HOME}/bin/instthaw >> $LOGFILE

if [ $? -gt 0 ]
  then
    echo "Error : Cannot THAW  $PRIMARY_INSTANCE" |tee -a  $LOGFILE
    ExitEmail
  exit 20
fi

#Step : 4 Create Directory for mount snapshot
echo "mkdir -p /epic/${PRIMARY_INST}01ss"|tee -a $LOGFILE
/usr/bin/mkdir -p /epic/${PRIMARY_INST}01ss
if [ $? -gt 0 ]
  then
    echo "Error : Cannot create  file system as ${PRIMARY_INST}01ss " |tee -a  $LOGFILE
    ExitEmail
  exit 20
fi

#Step 4 : Mount snapshot to directory

echo "mount -o ro,nouuid  /dev/${PRIMARY_INST}vg/${PRIMARY_INST}01ss /epic/${PRIMARY_INST}01ss"|tee -a $LOGFILE
/usr/bin/mount -o ro,nouuid  /dev/${PRIMARY_INST}vg/${PRIMARY_INST}01ss /epic/${PRIMARY_INST}01ss 
if [ $? -gt 0 ]
  then
    echo "Error : Cannot mount to snapshot file system" |tee -a  $LOGFILE
    ExitEmail
  exit 20
fi

echo "Snapshot create for $1 as ${PRIMARY_INST}01ss successfully">> $LOGFILE
/usr/bin/df -k | grep -i ${PRIMARY_INST}|tee -a $LOGFILE
/usr/sbin/lvs -a -o +devices|grep -i ${PRIMARY_INST}|tee -a $LOGFILE

##################Email the log. Email is not setup on the server
tail -5 $LOGFILE  | mail -s "create_ss.ksh $PRIMARY_INST  report for $(date +%Y%m%d_%H%M%S)" -a $LOGFILE $MAILGRP
