#nlignes=$(last erwan | wc -l)
#nlignes=$(expr $nlignes - 2)
nlignes=$(cat /var/log/auth.log | grep "session opened for user erwan" | wc -l)
time=$(date +"%d-%m-%y-%H:%M")
outputfile="number_connection_${time}"

cd /home/erwan/shell.exe/Job_8/

echo $nlignes > $outputfile

tar -cf "./Backup/backup_${time}.tar" $outputfile
