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
#lls $INCOMING/*.csv
cd Reports/
ls *
lcd $INCOMING
mget *  
#lls $INCOMING
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


##############Additional requirement Eric Bruning#####################
FileCnt=$(ls -l $INCOMING/*.csv|grep -v '^d'|grep -v "^total"|wc -l)
echo "File(s) found $FileCnt" |tee -a $LOGFILE
if [ $FileCnt -gt 0 ];
then
for file in $(ls $INCOMING/*.csv)
 do 
  echo "Processing File $file........"|tee -a $LOGFILE
  wc -l $file |tee -a $LOGFILE
  echo "Removing headers from $file"|tee -a $LOGFILE
  sed -i "1d" $file
  wc -l $file|tee -a $LOGFILE
  echo "Correcting/seperating Date and Time for $file"|tee -a $LOGFILE
  #file_name_wo_ext=$(echo $file|cut  -f1 -d.)
  #cp $file $file_name_wo_ext.txt
  #touch $file $file_name_wo_ext.sem
  awk -F, '{
    split($11, datetime, " ");
    date = datetime[1];
    time = datetime[2] " " datetime[3];
    $11 = date "," time;
    print $0;
}' OFS=, $file > $INCOMING/DetailedReportUnity.txt
####Generating a sem file
echo "Processing completed for $file. Moving $file to archive folder"|tee -a $LOGFILE
mv $file $INCOMING/archive/
echo "Creating sem file as $INCOMING/DetailedReportUnity.sem"
touch $INCOMING/DetailedReportUnity.sem
 done
exit 0
fi
echo "----------------------No files founds to transfer---------------------------"|tee -a $LOGFILE
