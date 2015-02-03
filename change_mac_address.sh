#!/bin/bash

green='\033[0;32m'
orange='\033[1;33m'
cyan='\033[1;36m'
red='\033[1;31m'

NC='\033[0m'


echo "${green}Running Mac Address Changer"
echo "\tby Gareth George // Edits by Yash Plorer${NC}"
echo "Allows you to change your mac address if blocked by network admins"
echo "Please connect to the type of internet you intend to use; we'll disconnect it for you when the time is right. Hit enter to confirm"
read
echo "${orange}Current Mac Address:${NC}"
for ((i=0; i<2; ++i));
do
	stat=`ifconfig en${i} | grep status`
	if [[ "$stat" != *"inactive"* ]]; then
	  	targetNetwork="en${i}"
	  	break
	fi
done
ifconfig "${targetNetwork}" | grep ether
oldMAC=`ifconfig "${targetNetwork}" | grep ether`

echo "${green}Generating a random mac address:${NC}"
macAddr=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
echo "\t$macAddr"

echo "\nNOTE:this might ask for admin privlatges since we're using sudo"
echo "NOTE: if this freezes for more than five seconds press ctrl+c"
echo "press enter to continue"
read
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
sudo ifconfig "${targetNetwork}" ether $macAddr
#sudo ifconfig "${targetNetwork}" Wi-Fi $macAddr

echo "${green}Your mac address should now be spoofed${NC}"
echo "press enter to run checks and confirm"
read
newMAC=`ifconfig "${targetNetwork}" | grep ether`
if [ "$oldMAC" != "$newMAC" ]; then
	echo "${green}Your mac address is now...${NC}"
	echo $newMAC
	echo "Spoofing successful! Go forth and excersize your right to access the information of the world."
else
	echo "Spoofing failed."
	echo "${red}Your mac address is still...${NC}"
	echo $newMAC
	echo "We recommend that you try running the script again. It's possible that it works on another attempt. If this isn't the case, feel free to report an issue on the Git."
fi