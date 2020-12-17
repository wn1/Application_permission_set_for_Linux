#!/bin/bash

echo "Plus permission"

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

read -p "Select permissions mod
1. rwx
2. r-x
3. r--
" modSelect

if [[ $modSelect = 1 ]]; then
    setMod=rwx
elif [[ $modSelect = 2 ]]; then
    setMod=r-x
elif [[ $modSelect = 3 ]]; then
    setMod=r--
else
    echo "Select is unknown. Cancel."
    exit 0 
fi


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

sudo chown root:$permission -c "$path"
sudo chmod g+$setMod -c "$path"

echo "ok"
