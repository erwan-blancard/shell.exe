echo "password" | sudo -S cd .	#TEMPORARY FIX SINCE ROOT CRONTAB FOR SUDO DOESN'T WORK

cd /home/erwan/shell.exe/Job_9/

while IFS="," read -r ID NAME LNAME MDP GROUP
do

if [ ! $ID == "Id" ]; then

	NAME="${NAME} ${LNAME}"
	GROUP="${GROUP//$'\r'/}"		#removes return character (\r) from string GROUP

       	if [ $GROUP == "User" ]; then
       	       echo "Creating user: ${NAME} with ID ${ID}, MDP ${MDP}, GROUP ${GROUP}"
       	       sudo useradd --non-unique --badnames -u $ID -p $(openssl passwd -1 $MDP) "${NAME}" #|| echo "Failed to add user: ${NAME}"

       	elif [ $GROUP == "Admin" ]; then
       	       echo "Creating admin: ${NAME} with ID ${ID}, MDP ${MDP}, GROUP ${GROUP}"
       	       sudo useradd --non-unique --badnames -u $ID -G sudo -p $(openssl passwd -1 $MDP) "${NAME}" #|| echo "Failed to add admin: ${NAME}"

       	else
       	       echo "User's role is invalid !"
       	fi
fi
#done < Shell_Userlist.csv
done < <(grep "" Shell_Userlist.csv)			#fixes last line skip
#done < <(tail -n +2 Shell_Userlist.csv)		#removes header, but last line isn't readed due to no "\r" in last line.
