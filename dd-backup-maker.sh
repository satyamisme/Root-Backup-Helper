#!/system/bin/sh



##
# dd-backup helper script
# inspired by bigrammy @ xda-developers

# This Gem will find your by-name paths and add them 
# to a sh file. But wait there's more
# it also Runs the created shell to make the backup for you

## Declairing the basic folders and File names to use ##
folder="/sdcard/dd-backup"
script="dd-backup.sh"
script2="dd-backup-boot-recovery.sh"
touch "$script"
touch "$script2"
echo "making dd-backup folder"
mkdir "$folder"
### Make Full Backup Script ###
#echo "#!/data/data/com.termux/files/usr/bin/bash" > $script
echo "#!/system/bin/sh" > "$script"
echo "" >> "$script"
echo "" > partitions.txt
basefile=$(ls /dev/block/platform/*/*/by-name/boot* | head -1) 2> /dev/null
base=$(dirname $basefile)

for x in $(ls $base); do
	if [ $x != userdata ]; then
		echo dd if="$base"/$x of="$folder"/$x bs=1048576 >> "$script"
		echo $base/$x >> partitions.txt
	fi
done
echo "" >> "$script"
if ls $base/boot > /dev/null 2>$1 ; then
    ### Make Boot Recovery Backup Script ###
    echo "#!/system/bin/sh" > "$script2"
    echo "" >> "$script2"
    echo dd if="$base"/boot of="$folder"/boot >> "$script2"
    echo dd if="$base"/recovery of="$folder"/recovery >> "$script2"
    echo "" >> "$script2"
fi
### Set Permissions On scripts ###
chmod +x "$script"
chmod +x "$script2"
echo ""
echo "dd-backup.txt created with no user input required"
echo ""
echo ""
echo "Hit @diplomatic THANKS button for mtk-su!!"
echo ""
echo ""
echo "Hit My THANKS Button Cheers @bigrammy"


echo "----------------------------------------------------------------------------"
PS3='Please enter your choice number: '
options=("Run ALL Backups 1" "Run Boot-Recovery Backup 2" "EXIT 3")
select opt in "${options[@]}"
	do
		case $opt in
			"Run ALL Backups 1")
				./"$script"
				echo "press enter to exit"
					read \n
				exit
			;;
			"Run Boot-Recovery Backup 2")
				./"$script2"
				echo "press enter to exit"
					read \n
				exit
			;;
			"EXIT 3")
				echo "press enter to exit"
					read \n
				exit 
			;;
			*) echo invalid option;;
		esac
	done


exit
