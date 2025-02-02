for i in $((iris qlist)|awk -F^ '{print $2"/"$5}'); 
do echo $i; 
awk -F, '/^\[Mirrors\]/{getline; print $7}' $i;
 done
