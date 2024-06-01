#!/bin/bash

function killexp() {
#----- Auto Remove Vless
data=( `cat /etc/xray/vless.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#& $user" "/etc/xray/vless.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^#& ${user} ${exp}/,/^},{/d" /etc/xray/vless.json
rm -f /var/www/html/${user}.txt
rm -f /etc/usr/${user}.txt
sed -i "/^### ${user} ${exp}/d" /etc/.vless.db
systemctl restart vless > /dev/null 2>&1
fi
done
}

function log() {
cd
clear
data=(`find /var/log/ -name *.log`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
data=(`find /var/log/ -name *.gz`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
data=(`find /var/log/ -name *.err`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
data=(`find /var/log/ -name mail.*`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
echo > /var/log/syslog
echo > /var/log/btmp
echo > /var/log/messages
echo > /var/log/debug
echo > /var/log/syslog
echo > /var/log/btmp
echo > /var/log/messages
echo > /var/log/debug
echo > /var/log/debug
echo > /var/log/messages
echo > /var/log/lastlog
echo > /var/log/user.log
echo > /var/log/wtmp
echo -e ""
echo -e " ${g} Clear Log Berhasil ${NC}"
echo ""
}

function cache() {
sync; echo 1 > /proc/sys/vm/drop_caches
sync; echo 2 > /proc/sys/vm/drop_caches
sync; echo 3 > /proc/sys/vm/drop_caches
}

if [[ ${1} == "clearcache" ]]; then
cache
elif [[ ${1} == "clearlog" ]]; then
log
elif [[ ${1} == "exp" ]]; then
killexp
else
echo >/dev/null 2>&1
fi
