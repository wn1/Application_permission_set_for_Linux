#!/bin/bash

shdir=$(dirname "$0")

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

echo "shdir: $shdir"

read -p '0. Start gitk
1. Terminal
2. Smart-git
3. Qgit
4. Gitg
5. Ssh-add
Select: ' select

if [[ $select = '0' ]]; then
   app=gitk
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select = '1' ]]; then
   app=gnome-terminal
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select = '2' ]]; then
   app=smart-git
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select = '3' ]]; then
   app=qgit
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select = '4' ]]; then
   app=gitg
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select = '5' ]]; then
   app="$shdir/ssh-agent-add-key.sh"
   permission=permission-git-write
#   params=
#   appDirList=
fi

echo "app: $app permission: $permission params: ${params[@]} appDirList: ${appDirList[@]}"

if [[ -z $app ]]; then
   echo 'Unknown selected: $select' 
   exit 0
fi

echo "Start sudo -g $permission -E $app $params"
sudo -g $permission -E $app $params


