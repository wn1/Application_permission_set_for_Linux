#!/bin/bash

echo "Check app dir for permissions"

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
        -useSpecificator) useSpecificator=$2
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

echo "app: $app permission: $permission useSpecificator: $useSpecificator params: ${params[@]} appDirList: ${appDirList[@]}"

if [[ $useSpecificator = reset-permissions-app ]]; then
    userForApp=$USER
else
    userForApp='root'
fi

for path in ${appDirList[@]}
do
    if ! [[ -e $path ]]; then 
        echo "Directory $path not exists ------------"
        continue;
    fi

    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    
    echo "file: $path
    owner: $uname:$gname
    mod: $mod"  

    if [[ $uname != $userForApp || $gname != $permission || $mod != $appMod ]]; then
        needChange=1
        break
    fi
done

#Check result is ok?
code=$?
if [[ $code != 0 ]]; then 
    echo "Check no ok, code: $code"
    exit $code
fi

if [[ $needChange -eq 1 ]]; then
    read -p "In this application will be used changes for app dirrectory:
owner change for 
    $userForApp:$permission
mod change to 
    $appMod
Tape yes for confirm this changes: " confirm
    if [[ $confirm == 'yes' ]]; then
        changeConfirm=1
    else
        echo "No confirm for changes, exit"
        exit 100
    fi
fi

for path in ${appDirList[@]}
do

    if ! [[ -e $path ]]; then 
        continue;
    fi

    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    echo Check $path owner

    if [[ $uname != $userForApp || $gname != $permission ]]; then
        echo Change $path owner from $uname:$gname to $userForApp:$permission
        sudo chown $userForApp:$permission $path
        #Check result is ok?
        if [[ $? != 0 ]]; then 
            exit $?
        fi
    fi
    echo Check $path mod
    if [[ $mod != $appMod ]]; then
        echo Change $path mod from $mod to $appMod
        sudo chmod $appModN $path
        #Check result is ok?
        if [[ $? != 0 ]]; then 
            exit $?
        fi
    fi
done

echo "Ok"

#Check 2

if [[ $needChange -eq 1 ]]; then
    ./sh-scripts/check2-application.sh -app $app -permission $permission -useSpecificator $useSpecificator -params ${params[@]} -appdirlist ${appDirList[@]}
    scriptExitCode=$?
    if [[ $scriptExitCode != 0 ]] 
    then
       exit $scriptExitCode     
    fi
fi


