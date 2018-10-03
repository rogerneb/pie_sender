# pie_sender
Bash script that synchronizes retropie machines.

PieSender will copy the roms, saves and statuses from local retropie to another target retropie.

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
 - Remember to reboot the target when PieSender finishes.

HOW TO USE:
1. Copy the file pie_sender.sh to the retropie from where you want to send the entire content.
Preferably in a folder, for example in /home/pi/scripts

2. Gives write permissions to the file: "chmod + x pie_sender.sh".

3. Run the script with: "./pie_sender".

4. Follow the steps.


This script comes with no guarantee.
