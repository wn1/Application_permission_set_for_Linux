#!/bin/bash

echo "Minus permission"

appMod="drwxrwx---"
appModN="770"

while [ -n "$1" ]
do
    p2check=${2:0:1}

    if [[ $p2check == "-" ]]; then
        shift
        continue
    fi

    case "$1" in
        -app) app=$2
            shift ;;
        -permission) permission=$2
            shift ;;
        -params) 
            shift
            let i=0
            while [[ ! -z ${1:0:1} && ${1:0:1} != "-" ]]
            do
              params[i]=$1
              let i=$i+1
              shift
            done;;
        -appdirlist) 
            shift
            let i=0
            while [[ ! -z ${1:0:1} && ${1:0:1} != "-" ]]
            do
              appDirList[i]=$1
              let i=$i+1
              shift
            done
    esac
    shift
done

read -p "Input path for permission (type * for use grafical user interface): " path

if [[ $path = "*" ]]; then 
    path=$(zenity --filename ~/ --file-selection --directory)
    echo "Select path: $path"
    if [[ -z $path ]]; then
        echo "Path is unknown. Cancel."
        exit 0    
    fi 
else
    pathStart=${path:0:1}
    if [[ $pathStart = "'" ]];then
        path=${path:1: -1}
    fi
fi

echo "app: $app permission: $permission params: ${params[@]} appDirList: ${appDirList[@]}"
echo "Change permission for path: $path"

sudo chown $USER:$USER -c "$path"

usedMod=$(ls -l -d "$path" | awk '{print $1}');
echo "usedMod: $usedMod"
setMod=${usedMod:1:4}

sudo chmod g=$setMod -c "$path"

echo "ok"
