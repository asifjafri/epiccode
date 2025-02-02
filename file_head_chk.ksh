####Author: Asif Jafri Jan 20 2025"
####Script checks bedding file for 0 rows"
####Once 0 rows found. Files is addedd headers only"
####
#!/bin/bash
MOVEDATE=(`date +%d%m%Y`)
CHKFILE=PHC_RG_RC_BedCapacity_${MOVEDATE}.csv
echo $CHKFILE
HOME_FOLDER=/epicfiles/nonprdfiles/misc/cogito/UnityBedCensus/Unity
mkdir -p /home/epicadm/scripts/log/HeaderCheck/$MOVEDATE
LOG=/home/epicadm/scripts/log/HeaderCheck/$MOVEDATE/chkfileheader.log
echo "Checking for $HOME_FOLDER/$CHKFILE" |tee -a  $LOG
if [ -f $HOME_FOLDER/$CHKFILE ];
 then
   linecnt=$(cat $HOME_FOLDER/$CHKFILE|wc -l)
   echo "$HOME_FOLDER/$CHKFILE exists with $linecnt lines."|tee -a  $LOG
  if [[ $linecnt -eq 0 ]]
    then
    echo "Replacing empty file with songle line heaider" |tee -a  $LOG
    cat /home/epicadm/scripts/PHC_RG_RC_BedCapacity_headers.txt >> $HOME_FOLDER/$CHKFILE
    cat $HOME_FOLDER/$CHKFILE|tee -a  $LOG
    ###cat $LOG | mailx -s "Vitalfile transfer failure" xxxxxxx@xxxxxx.com
    exit 0
    else
    echo "File found with > 0 rows successfull.Not doing anything"|tee -a  $LOG
    exit 0
  fi
fi
echo "File NOT found $HOME_FOLDER/$CHKFILE"

