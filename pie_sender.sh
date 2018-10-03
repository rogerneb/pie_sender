#!/bin/bash

#### WELCOME ###
function welcome(){
	clear
	echo ""
	echo "################################################"
	echo "#             Welcome to PieSender             #"
	echo "######################################### v0.7 #"
	echo ""

	echo "Want to see instrucctions? [Y/N]"
	echo -n "> "; read instructions
	echo ""

	#instructions
	if [[ $instructions == "y" || $instructions == "Y" ]]; then
		echo "PieSender will copy the roms, saves and statuses from local retropie to another target retropie.

Uses a SSH connection and rsync.

 PieSender will synchronize:
  - Roms.
  - Bios.
  - Game files  and savestates.
  - Gamelists, artwork covers and game info.

 Note that:
 - Roms, saves, savestates, artworks, and gamelists was overwritten in target.
 - You must know the IP address of the target.
 - You must know the user:password of the target (default: pi:retropie).
 - In each synchronized directory the target password will be requested. You can avoid this, creating a key system for both retropie.
 - Remember to reboot the target when PieSender finishes.

 This script comes with no guarantee.
"
		echo "- Press enter to continue -"
		read key
	fi
}
### END WELCOME ###

### GET THE TARGET ###
function get_target(){
key="y"
while [[ $key == "y" || $key == "Y" ]]; do
	echo "Type the target IP (ex. 192.168.1.10)"
	echo -n "> "; read target
	echo ""

	ping -c 1 $target>/dev/null #ping the target

	if [[ $? -eq 0 ]]; then #ping responses ok. Accessible. Let's go
		echo -e "\e[92m"$target" seems available.\e[0m"
		sleep 2
		key=0
		lets_go
	else #the target is not correct. Repeat if user wants.
	  echo -e "\e[31m"$target" seems not available.\e[0m\n"
		echo "Make sure that the target is powered on and the IP is correct."
		echo ""
		sleep 2
		echo "Try another IP? [Y/N]"
		echo -n "> "; read key
		echo ""
		if [[ $key != "y" && $key != "Y" ]]; then
			aborting
		fi
	fi
done
}
### END GET THE target ####

### LETS GO ###
function lets_go() {
	echo "Now we can connect to host with IP: "$target
	sleep 1
	echo "Specify the user in the target. By default is pi."
	echo -n "> "; read user
	sleep 1
    echo ""
	echo "Remember this: The contents in the target will be overwritten."
	echo "Are you really sure? [Y/N]"
	echo -n "> "; read sure
	echo ""
	if [[ $sure != "y" && $sure != "Y" ]]; then
		aborting
	else
		#SYNC
		#ROMS
		echo -e "\e[35mSynchronizing the roms.\e[0m\n"
		sleep 1
		rsync -avzr ~/RetroPie/roms/ ssh $user@$target:~/RetroPie/roms/
		echo ""
		#BIOS
		echo -e "\e[35mSynchronizing the systems bios.\e[0m\n"
		sleep 1
		rsync -avzr ~/RetroPie/BIOS/ ssh $user@$target:~/RetroPie/BIOS/
		echo ""
		#DOWNLOADED IMAGES
		echo -e "\e[35mSynchronizing the cover artworks.\e[0m\n"
		sleep 1
		rsync -avzr ~/.emulationstation/downloaded_images/ ssh $user@$target:~/.emulationstation/downloaded_images/
		echo ""
		#SYSTEMS GAMELISTS
		echo -e "\e[35mSynchronizing the Gamelists.\e[0m\n"
		sleep 1
		rsync -avzr ~/.emulationstation/gamelists/ ssh $user@$target:~/.emulationstation/gamelists/
		echo ""

		#SYSTEMS LIST NOT WORKING. PERMISION FAIL.
		#echo -e "\e[35mSynchronizing the Systemslist.\e[0m\n"
		#sleep 1
		#rsync -avzr /etc/emulationstation ssh $user@$target:/etc/emulationstation


		#PURGE
		#ROMS
		echo -e "\e[35mPurging the roms.\e[0m\n"
		sleep 1
		rsync -avh ~/RetroPie/roms/ ssh $user@$target:~/RetroPie/roms/ --delete
		echo ""
		#BIOS
		echo -e "\e[35mPurging the system bios.\e[0m\n"
		sleep 1
		rsync -avh ~/RetroPie/BIOS/ ssh $user@$target:~/RetroPie/BIOS/ --delete
		echo ""
		#DOWNLOADED IMAGES
		echo -e "\e[35mPurging the cover artworks.\e[0m\n"
		sleep 1
		rsync -avh ~/.emulationstation/downloaded_images/ ssh $user@$target:~/.emulationstation/downloaded_images/ --delete
		echo ""
		#SYSTEMS GAMELISTS
		echo -e "\e[35mPurging the Gamelists.\e[0m\n"
		sleep 1
		rsync -avh ~/.emulationstation/gamelists/ ssh $user@$target:~/.emulationstation/gamelists/ --delete
		echo ""

		#SYSTEMS LIST NOT WORKING. PERMISION FAIL.
		#echo -e "\e[35mPurging the Systemslist.\e[0m\n"
		#sleep 1
		#rsync -avh /etc/emulationstation ssh $user@$target:/etc/emulationstation --delete
		#echo ""

		the_end
	fi

}
### END LETS GO ###

### ABORTING ###
function aborting (){
	echo "Aborted."
	echo ""
}
### END ABORTING ###

### THE END ###
function the_end (){
	echo "PieSender finishes. You must reboot the target retropie."
	echo "See you ;-)"
}

###	END THE END ###


### MAIN ###
welcome
get_target
### END MAIN ###
