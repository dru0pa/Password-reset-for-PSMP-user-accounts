#!/bin/bash
#CyberArk scritp to reset the psmpadbridgeserveruser.cred, psmpappuser.cred and psmpgwuser.cred details
#The password is only changed on the PSMP server.
#The password for the accounts will still need to be changed making use of the PriverArk Client.
#The server will pick up the hostname of the server placing that in the required place in the command to reset the password.
#All accounts will have their password changed in the default location.
#Make the required changes if the server is running RHEL8
#Script is written by Andrew 
#email dru0pa@gmail.com


echo This script will change the password in the following files:
echo psmpadbridgeserveruser.cred
echo psmpappuser.cred
echo psmpgwuser.cred
#Getting hostname and storing as the variable $HN
HN=`hostname`
echo Host name of the server is $HN
#shorten account user name to 28 charachers
echo PSMP_ADB_`hostname` | sed 's/\(.\{28\}\).*/\1/' > PSMP_ADB.txt

echo PSMPApp_`hostname`| sed 's/\(.\{28\}\).*/\1/' > PSMPAPP.txt

echo PSMPGW_`hostname` | sed 's/\(.\{28\}\).*/\1/' > PSMPGW.txt

HN1=`cat PSMP_ADB.txt`
HN2=`cat PSMPAPP.txt`
HN3=`cat PSMPGW.txt`

#requesting the password that will be used by the accounts as the variable $pass
echo Type the password that will be used by all the accounts
read pass
#setting the password for the below accounts
/opt/CARKpsmp/bin/createcredfile psmpadbridgeserveruser.cred Password -Username $HN1 -Password $pass -EntropyFile
/opt/CARKpsmp/bin/createcredfile psmpappuser.cred Password -Username $HN2 -Password $pass -EntropyFile
/opt/CARKpsmp/bin/createcredfile psmpgwuser.cred Password -Username $HN3 -Password $pass -EntropyFile

mv -f psmpadbridgeserveruser.cred /etc/opt/CARKpsmpadb/vault/
mv -f psmpadbridgeserveruser.cred.entropy /etc/opt/CARKpsmpadb/vault/
mv -f psmpappuser.cred /etc/opt/CARKpsmp/vault/
mv -f psmpappuser.cred.entropy /etc/opt/CARKpsmp/vault/
mv -f psmpgwuser.cred /etc/opt/CARKpsmp/vault/
mv -f psmpgwuser.cred.entropy /etc/opt/CARKpsmp/vault/

#Checking the files were updated with new time stamps
echo ls of the files to see if there was a change
ls -lsh /etc/opt/CARKpsmpadb/vault/psmpadbridgeserveruser.cred
ls -lsh /etc/opt/CARKpsmpadb/vault/psmpadbridgeserveruser.cred.entropy
ls -lsh /etc/opt/CARKpsmp/vault/psmpappuser.cred
ls -lsh /etc/opt/CARKpsmp/vault/psmpappuser.cred.entropy
ls -lsh /etc/opt/CARKpsmp/vault/psmpgwuser.cred
ls -lsh /etc/opt/CARKpsmp/vault/psmpgwuser.cred.entropy
#Checking the files where updated content
echo catting the files
cat /etc/opt/CARKpsmpadb/vault/psmpadbridgeserveruser.cred
cat /etc/opt/CARKpsmp/vault/psmpappuser.cred
cat /etc/opt/CARKpsmp/vault/psmpgwuser.cred
#restarting the CyberArk services
echo restarting PSM for SSH server
#systemctl restart psmpsrv-psmpaserver	#RHEL8
service psmpsrv restart psmp
echo restarting PSM for SSH AD Bridge server
#systemctl restart psmpsrv-psmpdbserver	#RHEL8
service psmpsrv restart psmpadb
#echo restarting both PSM for SSH and the PSM for SSH AD Bridge server
#service psmpsrv restart
#systemctl restart psmpsrv	#RHEL8
#cleanup
rm -rf PSMP_ADB.txt
rm -rf PSMPAPP.txt
rm -rf PSMPGW.txt

echo Finished
