#!/bin/bash

MEM=$(grep -o "Memory:\ [0-9]*" /var/log/Xorg.0.log | grep -Eo "[0-9]+")
#MEMORY=$(grep -o ".*Memory: .*" /var/log/Xorg.0.log | cut -d \  -f 9)
let MEM=$MEM/1024
echo $MEM

zenity --width=600 --height=400 --info --text "By pressing the OK button you declare to accept our license. \n 
Developed by:\n Gianmaria Generoso, admin of www.italiaunix.com.\n Alberto Pau - DebInst creator https://github.com/TheGatorade/debinst \n
GNU GPL v3 License - Available at \n https://raw.githubusercontent.com/Kryuko/ue3_linux_opti/master/LICENSE"
       --title="License" \
	#--text="Inserisci la tua memoria video in MB" \
       #--checkbox="I read and accept the terms."

let MEMORY=$MEM-128

zenity --width=600 --height=400 --info \
--title="GPU Memory" \
--text="Your GPU memory is $MEM\MB, but it will be set to $MEMORY\MB to avoid problems." \
echo $MEMORY 

find ~/.local/share/ -type f -iname *.ini -exec sed -inr "s/^PoolSize=.*/PoolSize=$MEMORY/g" {} \;

zenity --width=600 --height=400 --info --text "All your UE3 Games are fully optimized to $MEMORY MB"
HALFMEMORY=$(($MEM / 4))
echo $HALFMEMORY

find ~/.local/share/ -type f -iname *.ini -exec sed -inr "s/^MemoryMargin=.*/MemoryMargin=$HALFMEMORY/g" {} \;
zenity --width=600 --height=400 --info --text "MemoryMargin has been set to $HALFMEMORY MB"

exit