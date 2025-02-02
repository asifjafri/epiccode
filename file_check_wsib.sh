HOST='sftp.GatewayStaging.TelusHealthFinance.com'
USER='StJosephHCin'
HOME_FOLDER=/epicfiles/nonprdfiles/misc/ComputerTalk
INCOMING=$HOME_FOLDER/incoming
OUTGOING=$HOME_FOLDER/outgoing
MOVEDATE=(`TZ=CST+48 date +%m%d%Y`)
REMOTEPATH='Reports'
echo $MOVEDATE
/usr/bin/sftp -vvv -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST<<EOF
ls -al *
EOF
