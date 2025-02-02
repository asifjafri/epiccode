#WSIB submission file   "/epicfiles/prdfiles/misc/claims/WSIB/active /epicfiles/prdfiles/misc/claims/WSIB\archive 2 Destination SJHC SFTP TELUSHEALTH -> folder \inbound\
#\\fileshare.local.unity\teams\Accounts_Receivable\001EpicJobQueue\WSIB\EMERGIS"        8-5     Every 15 min
#WSIB EOB file  SJHC SFTP TELUSHEALTH -> folder \outbound\      "2 Destination
#/epicfiles/prdfiles/misc/claims/remit/load
#\\fileshare.local.unity\teams\Accounts_Receivable\001EpicJobQueue\WSIB\EOB"    8-5     Every 15 min
#Set it up 15 min every hours. Pratheep script will run at 5 min / hour to move th efile to windows.

HOST='sftp.Gateway.TelusHealthFinance.com'
USER='StJosephHCin'
HOME_FOLDER=/epicfiles/prdfiles/misc/claims/remit
INCOMING=$HOME_FOLDER/load
MOVEDATE=(`date +%m%d%Y`)
REMOTEPATH='outbound'
echo $MOVEDATE
mkdir -p /home/epicadm/scripts/log/wsib/$MOVEDATE
LOGFILE=/home/epicadm/scripts/log/wsib/$MOVEDATE/file-retrive.log
/usr/bin/sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST<<EOF |tee -a $LOGFILE
cd $REMOTEPATH
cd EOB
pwd
ls *
lcd $INCOMING
lls $INCOMING
mget *  
EOF
 if [ $? -ne 0 ];
    then
    echo "File retrival from WSIB failed. $DATE" |tee -a  $LOG
    ###cat $LOG | mailx -s "Vitalfile transfer failure" xxxxxxx@xxxxxx.com
    exit 255
    else 
    echo "File retrival successfull."
  fi


