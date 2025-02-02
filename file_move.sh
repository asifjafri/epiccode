HOST='sftp3.icescape.com'
USER='unitytest'

#HOME_FOLDER=/home/asif-admin@Unity.local/scripts/ComputerTalk/
HOME_FOLDER=/epicfiles/nonprdfiles/misc/ComputerTalk
INCOMING=$HOME_FOLDER/incoming
OUTGOING=$HOME_FOLDER/outgoing
MOVEDATE=(`TZ=CST+48 date +%m%d%Y`)
REMOTEPATH='Imports/'
echo $MOVEDATE
mkdir -p /home/epicadm/scripts/log/$MOVEDATE
LOGFILE=/home/epicadm/scripts/log/$MOVEDATE/file-move.log
FileCnt=$(ls -l  $OUTGOING|grep -v '^d'|grep -v "^total"|wc -l)
if [ $FileCnt -gt 0 ];
then
echo "New files found in $OUTGOING. Total file ----> $FileCnt"|tee -a $LOGFILE
echo "Starting file transfer script for  $FileCnt files"|tee -a $LOGFILE
/usr/bin/sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST <<EOF |tee -a $LOGFILE
lcd $OUTGOING/
lpwd
lls -al *
##cd  $REMOTEPATH/
pwd
mput * Imports/
ls -al  Imports/
EOF
 if [ $? -ne 0 ];
    then
    echo "File transfer for $each failed. $DATE" |tee -a $LOGFILE
    ###cat $LOG | mailx -s "Vitalfile transfer failure" xxxxxxx@xxxxxx.com
    exit 255
    else 
    echo "File transferr successfull"|tee -a $LOGFILE
    find $OUTGOING/ -maxdepth 1  -type f -exec mv -f {} $OUTGOING/archive/ \;
    echo "file archived"|tee -a  $LOGFILE
    exit 0
  fi
fi
echo "----------------------No files founds to transfer---------------------------"|tee -a $LOGFILE
