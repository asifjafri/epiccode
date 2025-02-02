#!/bin/bash
iris qlist tst | grep 'Disaster Recovery^Connected' ;
if [ $? -eq 0 ] ;
then echo "I am a DR" ;
rsync -avzhe ssh uhtjtepdrodb:/epicfiles/nonprdfiles/misc/  /epicfiles/nonprdfiles/misc/  --delete
else echo "I am NOT a DR" ;
fi
