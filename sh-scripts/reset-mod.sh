#!/bin/bash

shdir=$(dirname "$0")

echo "shdir: $shdir"

echo "In selected directory: Remove executable flag from all files (change mod to 664) and change mod to 775 for all directory"

read -p '0. Change mod to 775 for all DIRECTORY
1. Remove executable flag from all FILES (change mod to 664)
2. Remove executable flag from all FILES (change mod to 664) and change mod to 775 for all DIRECTORY' select

if [[ $select = '0' ]]; then
   changeDirMod=775

elif [[ $select = '1' ]]; then
    changeDirMod=775
    changeFilesMod=664

elif [[ $select = '1' ]]; then
    changeFilesMod=664

fi

read -p 'Input directory path: ' dirPath

! [[ -e $changeFilesMod ]]; then 
    sudo find $dirPath -type f -exec chmod $changeFilesMod --changes {} \;
fi

! [[ -e $changeDirMod ]]; then 
    sudo find $dirPath -type d -exec chmod $changeDirMod --changes {} \;
fi

echo 'Ok'




