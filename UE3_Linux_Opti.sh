#!/bin/bash

language=$(echo $LANG | cut -c -5)

if [ $language == "it_IT" ]; then
    zenity --info --title="Licenza" \
    --text "PREMENDO OK ACCETTI LA NOSTRA LICENZA \n 
    Developed by:\n Gianmaria Generoso, admin of www.italiaunix.com.\n Alberto Pau - DebInst creator https://github.com/TheGatorade/debinst \n Davide Guidotti \n
    GNU GPL v3 License - Available at \n https://raw.githubusercontent.com/Kryuko/ue3_linux_opti/master/LICENSE"
else
    zenity --info --title="License" \
    --text "By pressing the OK button you declare to accept our license. \n 
    Developed by:\n Gianmaria Generoso, admin of www.italiaunix.com.\n Alberto Pau - also debinst creator https://github.com/TheGatorade/debinst \n Davide Guidotti \n
    GNU GPL v3 License - Available at \n https://raw.githubusercontent.com/Kryuko/ue3_linux_opti/master/LICENSE"
fi

MEM=$(grep -o "Memory:\ [0-9]*" /var/log/Xorg.0.log | grep -Eo "[0-9]+")

if [ "$MEM" == "" ]; then 
    menu=(256 512 1024 2048 4056 6104 8192 12248 16384)
        
    if [ $language == "it_IT" ]; then
        MEM=$(zenity --entry \
        --title="Inserisci memoria GPU" \
        --text="Inserisci la memoria della tua scheda video" \
        --entry-text "${menu[@]}")
    else
        MEM=$(zenity --entry \
        --title="Insert GPU Memory" \
        --text="Insert your GPU memory" \
        --entry-text "${menu[@]}")
    fi
else let MEM=$MEM/1024
fi

let MEMORY=$MEM-128
HALFMEMORY=$(($MEM / 10))
gamesFound=`find ~/.local/share/ -type f -iname *.ini -exec grep -l ^MemoryMargin {} \;`
timeStamp=`date +%Y-%m-%dT%H-%M-%S`

if [ $language == "it_IT" ]; then
    msg="La memoria della GPU rilevata è $MEM\MB ed i file di configurazione trovati dei giochi che usano l'engine UE3 sono:\n\n"
    msg+="$gamesFound\n\n"
    msg+="I valori della configurazione modificati saranno:\n\n"
    msg+="- PoolSize to $MEMORY\MB\n
    msg+="- MemoryMargin to $HALFMEMORY\MB\n\n"
    msg+="I file originali saranno conservati come \"(original file)_bck$timeStamp\"\n\n"
    msg+="Continuare?"

   zenity --question \
    --title="Conferma ottimizzazione" \
    --text="$msg"
else
    msg="Your detected GPU memory is $MEM\MB and the configuration files found for games using the UE3 engine are:\n\n"
    msg+="$gamesFound\n\n"
    msg+="the configuration values changed will be:\n\n"
    msg+="- PoolSize to $MEMORY\MB\n"
    msg+="- MemoryMargin to $HALFMEMORY\MB\n\n"
    msg+="The original files will be backed up as \"(original file)_bck$timeStamp\"\n\n"
    msg+="Continue?"

   zenity --question \
    --title="Confirm optimization" \
    --text="$msg"
fi

rc=$?
if [ "${rc}" == "1" ]; then
    echo "Program terminated by user."
    exit 1
fi

# Must run again to avoid the problem with spaces in files
# TODO: how to avoid the double run?
find ~/.local/share/ -type f -iname *.ini -exec grep -l ^MemoryMargin {} \; | while read srcPath; do
    cp "$srcPath" "$srcPath""_bck"$timeStamp
done

find ~/.local/share/ -type f -iname *.ini -exec sed -inr "s/^PoolSize=.*/PoolSize=$MEMORY/g" {} \;
find ~/.local/share/ -type f -iname *.ini -exec sed -inr "s/^MemoryMargin=.*/MemoryMargin=$HALFMEMORY/g" {} \;

if [ $language == "it_IT" ]; then
    zenity --info --text "Ottimizzazione terminata con successo, GG"
else
    zenity --info --text "Optimization successfully terminated, GG"
fi

exit
