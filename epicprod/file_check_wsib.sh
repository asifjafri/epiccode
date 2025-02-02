HOST='sftp.Gateway.TelusHealthFinance.com'
USER='StJosephHCin'
HOME_FOLDER=/epicfiles/prdfiles/misc/ComputerTalk
REMOTEPATH='Reports'
echo $MOVEDATE
/usr/bin/sftp -o IdentityFile=/home/epicadm/.ssh/id_rsa2 $USER@$HOST<<EOF
ls -al *
lls -al
EOF
