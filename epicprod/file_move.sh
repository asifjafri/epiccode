HOST='sftp3.icescape.com'
USER='unity'
HOME_FOLDER=/epicfiles/prdfiles/misc/ComputerTalk
INCOMING=$HOME_FOLDER/incoming
OUTGOING=$HOME_FOLDER/outgoing
MOVEDATE=(`date +%m%d%Y`)
REMOTEPATH='Imports'
echo $MOVEDATE
mkdir -p /home/epicadm/scripts/log/$MOVEDATE
LOGFILE=/home/epicadm/scripts/log/$MOVEDATE/file-move.log
FileCnt=$(ls -l  $OUTGOING|grep -v '^d'|wc -l)
if [ $FileCnt -gt 1 ];
then
echo "New files found in $OUTGOING. Total file ----> $FileCnt"|tee -a $LOGFILE
echo "Starting file transfer script for  $FileCnt files"|tee -a $LOGFILE
sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST <<EOF |tee -a $LOGFILE
lcd $OUTGOING/
lpwd
lls *
##cd  $REMOTEPATH/
pwd
mput * Imports/
ls -al Imports/
EOF
 if [ $? -ne 0 ];
    then
    echo "File transfer for $each failed. $DATE" |tee -a $LOGFILE
    ###cat $LOG | mailx -s "Vitalfile transfer failure" xxxxxxx@xxxxxx.com
    exit 255
    else 
    echo "File transferr successfull $DATE"|tee -a $LOGFILE
    find $OUTGOING/ -maxdepth 1  -type f -exec mv {} $OUTGOING/archive/ \;
    #mv $OUTGOING/ $OUTGOING/archive/
    echo "file archived"|tee -a  $LOGFILE
    exit 0
  fi
fi
echo "----------------------No files founds to transfer---------------------------"|tee -a $LOGFILE
##sftp $USER@$HOST<<EOF >sftp_log_file.log 2>&1 
##cd $DIR lcd $DIR/files mget *$FILEEXT1 
##rm *$FILEEXT1 
##quit 
##EOF
