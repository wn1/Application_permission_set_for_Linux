#Licence GPL v2
#Linux Tools for application

#select=''
#app=''
#permission=''
#params=''
#appDirList=''

#Permission group for change this script
internalChangePermission=permission-develop
internalChangePermissionGid=7700
#internalChangePermission=root
internalScriptMod="-rwxrwxr-x"
internalScriptModDir="drwxrwxr-x"
internalScriptModN="775"
desktopDirectory=~/Рабочий\ стол/
linksDirectory=./links

read -p '0. Start input app params
1. Firefox
2. +permission-file-archive: Nemo
3. Ssh: Git
4. Yandex-disk
5. Google-Drive
6. User-Backup
7. +Ntfs-disks: Nemo
8. Qt
9. Dolphin +root
10. +permission-develop: Nemo
11. +permission-android-develop: Android Studio
12. Yandex-browser
t. for test
For adding permissions to your directory use prefix + (+1, +2 etc)
For deleting permissions on your directory use prefix - (-1, -2 etc)
For find permissions on your directory use prefix ? (?1, ?2 etc)
For run nemo with selected permissions use prefix n ? (n1, n2 etc)
For run dolphin with selected permissions use prefix d ? (d1, d2 etc)
For run terminal with selected permissions use prefix t ? (t1, t2 etc)
For reset app from selected permissions use prefix rs-p ? (rs-p1, rs-p2 etc)
Select: ' select

if [[ $select = 't' ]]; then
   app=test
   permission=permission-develop
   permissionGid=7700
#   params=
   appDirList=(./test1 ./test2)

elif [[ ${select:0:1} = 't' ]]; then
   useApp=gnome-terminal
   select=${select:1}
#   useStartScript
   echo "Select: terminal"

elif [[ ${select:0:1} = 'n' ]]; then
   useApp=nemo
   select=${select:1}
   echo "Select: nemo"

elif [[ ${select:0:1} = 'd' ]]; then
   useApp=dolphin
   select=${select:1}
   echo "Select: dolphin"

elif [[ ${select:0:4} = 'rs-p' ]]; then
   useSpecificator=reset-permissions-app
   select=${select:4}
   echo "Select: dolphin"
fi

if [[ $select = '2' ]]; then
   app=nemo
   permission=permission-file-archive
   permissionGid=7702
#   params=
#   appDirList=

elif [[ $select = '3' ]]; then
   app=./sh-scripts/git-select.sh
   permission=permission-git-write
   permissionGid=7703
   startScript=1
#   params=
#   appDirList= 

elif [[ $select = '1' ]]; then
   app=firefox
   permission=permission-firefox
   permissionGid=7701
#   params=
   appDirList=(~/.mozilla ~/.cache/mozilla)

elif [[ $select = '6' ]]; then
   app=mintbackup
   permission=permission-backup
   permissionGid=7706
#   params=
#   appDirList=

elif [[ $select = '7' ]]; then
   app=nemo
   permission=permission-ntfs
   permissionGid=7707
#   params=
#   appDirList=

elif [[ $select = '10' ]]; then
   app=nemo
   permission=permission-develop
   permissionGid=7700
#   params=
#   appDirList=

elif [[ $select = '11' ]]; then
   app=$linksDirectory/android-studio.sh
   permission=permission-android-develop
   permissionGid=7711
#   params=$desktopDirectory
#   cdDir=$desktopDirectory
#   appDirList=

elif [[ $select = '12' ]]; then
   app=yandex-browser
   permission=permission-yandex-browser
   permissionGid=7712
#   params=$desktopDirectory
#   cdDir=$desktopDirectory
   appDirList=(~/.cache/yandex-browser-beta ~/.config/yandex-browser-beta ~/.yandex)

elif [[ $select = '13' ]]; then
   app=doublecmd
   permission=permission-doublecmd
   permissionGid=7713
#   params=$desktopDirectory
#   cdDir=$desktopDirectory
   appDirList=(~/.config/doublecmd)

fi

if [[ -n $useApp ]]; then
    app=$useApp
    startScript=$useStartScript
fi

#TODO select qreatest 3

if [[ -z $app ]]; then
   echo 'Unknown selected: $select' 
   exit 0
fi

echo "Selected:
    $select
app: 
    $app 
permission: 
    $permission
params: 
    "

for parameter in "${params[@]}"
do 
    echo "$parameter"
done

echo "appDirList: 
    "

for path in "${appDirList[@]}"
do 
    echo "$path"
done

echo "startScript: $startScript"

needChange=0

internalCheckFileList=(./start_app_plus_permission.sh ./sh-scripts/ ./sh-scripts/git-select.sh ./sh-scripts/check1-application.sh ./sh-scripts/check2-application.sh ./sh-scripts/ssh-agent-add-key.sh)

#Check internalChangePermission group exists 
#TODO read from backup
groupIsExists=$(grep -F -w $internalChangePermission /etc/group)
fileGroupBackup=./permission_groups_backup/$groupIsExists

if [[ -z $groupIsExists ]]; then
   echo Adding permission group: $internalChangePermission  
   sudo addgroup --gid $internalChangePermissionGid $internalChangePermission     
fi

#Check result is ok?
if [[ $? != 0 ]]; then 
    exit $?
fi

#Check this script for permissions
echo "Check this script for permissions"

for path in ${internalCheckFileList[@]}
do
    if ! test -e $path; then
       echo "error: File $path is empty" 
       exit 111
    fi
    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    
    echo "file: $path
    owner: $uname:$gname
    mod: $mod"   

    if [[ $uname != 'root' || $gname != $internalChangePermission || ($mod != $internalScriptMod && $mod != $internalScriptModDir) ]]; then
        needChange=1
        break
    fi
done

#Check result is ok?
if [[ $? != 0 ]]; then 
    exit $?
fi

if [[ $needChange -eq 1 ]]; then
    read -p "In this application will be used changes for this script:
owner change to 
    root:$internalChangePermission
mod change to 
    $internalScriptMod
Tape yes for confirm this changes: " confirm
    if [[ $confirm != 'yes' ]]; then
        echo "No confirm for changes, exit"
        exit 100
    fi

    for path in ${internalCheckFileList[@]}
    do
        uname=$(ls -l -d $path | awk '{print $3}');
        gname=$(ls -l -d $path | awk '{print $4}');
        mod=$(ls -l -d $path | awk '{print $1}');
        if [[ $uname != "root" || $gname != "$internalChangePermission" ]]; then
            echo Change $path owner from $uname:$gname to root:$internalChangePermission
            sudo chown root:$internalChangePermission $path
            #Check result is ok?
            if [[ $? != 0 ]]; then 
                exit $?
            fi
        fi
        if [[ $mod != $internalScriptMod && $mod != $internalScriptModDir ]]; then
            echo Change $path mod from $mod to *${internalScriptMod:1:9}
            sudo chmod $internalScriptModN $path
            #Check result is ok?
            if [[ $? != 0 ]]; then 
                exit $?
            fi
        fi
    done

else
    echo Ok.
fi

changeConfirm=0

#Check group exists 
#TODO read from backup
#TODO 
groupIsExists=$(grep -F -w $permission /etc/group)

if [[ -z $groupIsExists ]] 
then
   echo Adding permission group: $permission   
   sudo addgroup --gid $permissionGid $permission     
fi


#Backup permission group
fileGroupBackup=./permission_groups_backup/$groupIsExists
groupIsExists=$(grep -F -w $permission /etc/group)

echo 'Backup permission group check'

fileGroupBackupDir=./permission_groups_backup/

if ! [[ -e $fileGroupBackupDir ]]; then 
    echo "Make directory permission_groups_backup"
    mkdir $fileGroupBackupDir
# TODO backup from backup user
#    sudo chown root:$internalChangePermission $fileGroupBackupDir
    sudo chmod 770 $fileGroupBackupDir
fi

if [[ -n $groupIsExists && ! -e fileGroupBackup ]]; then
   echo Backup permission group: $permission 
#TODO replace
   echo $groupIsExists > ./permission_groups_backup/$permission    
fi

#Check result is ok?
if [[ $? != 0 ]]; then 
    exit $?
fi


#Link directory adding


if ! [[ -e $linksDirectory ]]; then 
    echo "Make directory $linksDirectory"
    mkdir $linksDirectory
# TODO backup from backup user
#    sudo chown root:$internalChangePermission $fileGroupBackupDir
    sudo chmod 770 $linksDirectory
fi

#Check application directory for permissions
./sh-scripts/check1-application.sh -app $app -permission $permission -useSpecificator $useSpecificator -params ${params[@]} -appdirlist ${appDirList[@]}
scriptExitCode=$? 
if [[ $scriptExitCode != 0 ]] 
then
   exit $scriptExitCode     
fi

#if [[ -n $cdDir ]] 
#then
#   cd $cdDir     
#fi

if [[ -n $startScript ]]; then
    echo "Start $app ${params[@]}"
    $app ${params[@]}
else
    echo "Start sudo -g $permission $app ${params[@]}"
    sudo -g $permission $app ${params[@]}
fi
