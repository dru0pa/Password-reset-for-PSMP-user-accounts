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
#requesting the password that will be used by the accounts as the variable $pass
echo Type the password that will be used by all the accounts
read pass
#setting the password for the below accounts
/opt/CARKpsmp/bin/createcredfile /etc/opt/CARKpsmpadb/vault/psmpadbridgeserveruser.cred Password -Username PSMP_ADB_$HN -Password $pass -EntropyFile
/opt/CARKpsmp/bin/createcredfile /etc/opt/CARKpsmp/vault/psmpappuser.cred Password -Username PSMPAPP.$HN -Password $pass -EntropyFile
/opt/CARKpsmp/bin/createcredfile /etc/opt/CARKpsmp/vault/psmpgwuser.cred  Password -Username PSMPGW_$HN -Password $pass -EntropyFile
#Checking the files were updated with new time stamps
echo ls of the files to see if there was a change
ls -lsh /etc/opt/CARKpsmpadb/vault/psmpadbridgeserveruser.cred
ls -lsh /etc/opt/CARKpsmp/vault/psmpappuser.cred
ls -lsh /etc/opt/CARKpsmp/vault/psmpgwuser.cred
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

echo Finished
