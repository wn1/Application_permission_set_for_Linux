#!/bin/bash

shdir=$(dirname "$0")

echo "shdir: $shdir"

echo "In selected directory: "

read -p '0. Remove executable flag from all FILES (change mod: u-x,g-x,o-x)
1. Change mod to 775 for all DIRECTORY
2. Change mod to 664 for all FILES
3. Change mod to 664 for all FILES and change mod to 775 for all DIRECTORY
' select

if [[ $select = '0' ]]; then
    changeDirMod=775
    filesModeXFlagRemove=1
elif [[ $select = '1' ]]; then
   changeDirMod=775
elif [[ $select = '2' ]]; then
    changeFilesMod=664
elif [[ $select = '3' ]]; then
    changeDirMod=775
    changeFilesMod=664
fi

read -p "Input directory path (type * for use grafical user interface): " path

if [[ $path = "*" ]]; then 
    path=$(zenity --filename ~/ --file-selection --directory)
    echo "Select path: $path"
    if [[ -z $path ]]; then
        echo "Path is unknown. Cancel."
        exit 0    
    fi  
else
    pathStart=${path:0:1}
    if [[ $pathStart = "'" ]]; then
        path=${path:1: -1}
    fi      
fi

if ! [[ -z $changeFilesMod ]]; then
    sudo find "$path" -type f -exec chmod $changeFilesMod --changes {} \;
fi

if ! [[ -z $filesModeXFlagRemove ]]; then
    sudo find "$path" -type f -exec chmod u-x,g-x,o-x --changes {} \;
fi

if ! [[ -z $changeDirMod ]]; then 
    sudo find "$path" -type d -exec chmod $changeDirMod --changes {} \;
fi

echo 'Ok'




