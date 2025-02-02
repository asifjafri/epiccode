HOST='sftp3.icescape.com'
USER='unity'
HOME_FOLDER=/epicfiles/prdfiles/misc/ComputerTalk
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
echo "Empty DetailedReportUnity.txt before processing incomming files.. $DATE" |tee -a  $LOG
cat /dev/null > $INCOMING/DetailedReportUnity.txt
sleep 2
echo "Checking incomming files from Computer Talk.....$DATE" |tee -a  $LOG
FileCnt=$(ls -l $INCOMING/*.csv|grep -v '^d'|grep -v "^total"|wc -l)
#ls -al $INCOMING/DetailedReportUnity.txt|tee -a $LOGFILE
echo "File(s) found $FileCnt" |tee -a $LOGFILE
sleep 2
if [ $FileCnt -gt 0 ];
then
for file in $(ls $INCOMING/*.csv)
 do 
  echo "Processing File $file........"|tee -a $LOGFILE
echo
echo
  cp $file $INCOMING/archive/
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
}' OFS=, $file >> $INCOMING/DetailedReportUnity.txt
sleep 2 
####Generating a sem file
echo "Processing completed for $file. Creating a sem file"|tee -a $LOGFILE
rm $file
echo
echo
touch $INCOMING/DetailedReportUnity.sem
sleep 2 
done
LineCnt=$(wc -l $INCOMING/DetailedReportUnity.txt)
echo "Coverting to ANSI from UTF8"
iconv -f UTF-8 -t ISO-8859-1//TRANSLIT -o $INCOMING/DetailedReportUnity.tmp $INCOMING/DetailedReportUnity.txt
mv  $INCOMING/DetailedReportUnity.tmp $INCOMING/DetailedReportUnity.txt
echo "All done....$LineCnt row availavle in DetailedReportUnity.txt"|tee -a $LOGFILE
echo "Exiting now $?.....$date"|tee -a $LOGFILE
exit 0
fi
echo "----------------------No files founds to transfer---------------------------"|tee -a $LOGFILE
