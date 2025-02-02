HOST='sftp3.icescape.com'
USER='unitytest'
HOME_FOLDER=/epicfiles/nonprdfiles/misc/ComputerTalk
INCOMING=$HOME_FOLDER/incoming
OUTGOING=$HOME_FOLDER/outgoing
MOVEDATE=(`TZ=CST+48 date +%m%d%Y`)
REMOTEPATH='Reports'
echo $MOVEDATE
mkdir -p /home/epicadm/scripts/log/$MOVEDATE
LOGFILE=/home/epicadm/scripts/log/$MOVEDATE/file-retrive.log
/usr/bin/sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST<<EOF |tee -a $LOGFILE
lls $INCOMING
cd Reports/
ls *
lcd $INCOMING
mget *  
lls $INCOMING
EOF
 if [ $? -ne 0 ];
    then
    echo "File retrival from ComputerTalk failed. $DATE" |tee -a  $LOG
    ###cat $LOG | mailx -s "Vitalfile transfer failure" xxxxxxx@xxxxxx.com
    exit 255
    else 
    echo "File retrival successfull. Removing files from ComputerTalk"
/usr/bin/sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST<<EOF2 |tee -a $LOGFILE
	cd Reports/
	ls *.csv
        rm *.csv
        ls *.csv
EOF2
  fi
