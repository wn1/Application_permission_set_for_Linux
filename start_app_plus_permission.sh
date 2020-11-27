#Licence GPL v2
#Linux Tools for application

#select=''
#app=''
#permission=''
#params=''
#appDirList=''

#Permission group for change this script
internalChangePermission=permission-develop
#internalChangePermission=root
internalScriptMod="-rwxrwx---"
internalScriptModN="770"

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
t. for test
For adding permissions to your directory use prefix + (+1, +2 etc)
For deleting permissions on your directory use prefix - (-1, -2 etc)
For find permissions on your directory use prefix ? (?1, ?2 etc)
Select: ' select

if [[ $select = 't' ]]; then
   app=test
   permission=permission-develop
#   params=
   appDirList=(./test1 ./test2)

elif [[ $select = '2' ]]; then
   app=nemo
   permission=permission-file-archive
#   params=
#   appDirList=

elif [[ $select = '3' ]]; then
   app = git-select.sh
   permission=permission-git-write
#   params=
#   appDirList= 

elif [[ $select = '1' ]]; then
   app=firefox
   permission=permission-firefox
#   params=
   appDirList=(~/.mozila ~/.cache/mozilla)

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
    $params 
appDirList: "

for path in "${appDirList[@]}"
do 
    echo "  $path"
done

needChange=0

internalCheckDirList=(./start_app_plus_permission.sh ./sh-scripts/git-select.sh)

#Check internalChangePermission group exists 
#TODO read from backup
groupIsExists=$(grep -F -w $internalChangePermission /etc/group)
fileGroupBackup=./permission_groups_backup/$groupIsExists

if [[ -z $groupIsExists ]]; then
   echo Adding permission group: $internalChangePermission  
   sudo addgroup $internalChangePermission     
fi

#Check this script for permissions
echo "Check this script for permissions"

for path in ${internalCheckDirList[@]}
do
    if ! test -e $path; then
       echo "error: File $path is empty" 
       exit 0
    fi
    uname=$(ls -l $path | awk '{print $3}');
    gname=$(ls -l $path | awk '{print $4}');
    mod=$(ls -l $path | awk '{print $1}');
    
    echo "file: $path uname: $uname gname: $gname mod: $mod"    

    if [[ $uname != 'root' || $gname != $internalChangePermission || $mod != $internalScriptMod ]]; then
        needChange=1
        break
    fi
done

if [[ $needChange -eq 1 ]]; then
    read -p "In this application will be used changes for this script:
owner change to root:$internalChangePermission
mod change to $internalScriptMod
Tape yes for confirm this changes: " confirm
    if [[ $confirm != 'yes' ]]; then
        echo "No confirm for changes, exit"
        exit 0
    fi

    for path in ${internalCheckDirList[@]}
    do
        uname=$(ls -l $path | awk '{print $3}');
        gname=$(ls -l $path | awk '{print $4}');
        mod=$(ls -l $path | awk '{print $1}');
        if [[ $uname != "root" || $gname != "$internalChangePermission" ]]; then
            echo Change $path owner from $uname:$gname to root:$internalChangePermission
            read -p 'Press enter' $enter
            sudo chown root:$internalChangePermission $path
        fi
        if [[ $mod != $internalScriptMod ]]; then
            echo Change $path mod from $mod to $internalScriptMod
            sudo chmod $internalScriptModN $path
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
fileGroupBackup=./permission_groups_backup/$groupIsExists

if [[ -z $groupIsExists ]] 
then
   echo Adding permission group: $permission   
   sudo addgroup $permission     
fi




#Backup permission group
groupIsExists=$(grep -F -w $permission /etc/group)

echo 'Backup permission group check'

if [[ -n $groupIsExists && ! -e fileGroupBackup ]] 
then
   echo Backup permission group: $permission 
#TODO replace
   echo $groupIsExists > ./permission_groups_backup/$permission    
fi

#Temporary exit point
read -p 'Press enter' $enter
exit 0

#Check application directory for permissions
if [ $needChange -eq 0]; then
    for path in ${appDirList[@]}
    do
        uname=$(ls -l $path | awk '{print $3}');
        gname=$(ls -l $path | awk '{print $4}');
        mod=$(ls -l $path | awk '{print $1}');
        if [ $uname != root -o gname != $permission -o mod != drwxrwx---]; then
            needChange = 1
            break
        fi
    done
fi

if [ $needChange -eq 1]; then
    read -p 'In this application will be used changes for app dirrectory:
owner change for root:$permission
mod change to drwxrwx---
Tape yes for confirm this changes: ' $confirm
    if [[ $confirm -eq yes ]]; then
        changeConfirm = 1
    else
        exit 0
    fi
fi

for path in ${appDirList[@]}
do
    uname=$(ls -l $path | awk '{print $3}');
    gname=$(ls -l $path | awk '{print $4}');
    mod=$(ls -l $path | awk '{print $1}');
    echo Check $path owner
    if [ $uname != root -o gname != permission]; then
        echo Change $path owner from $uname:$gname to root:$permission
        read -p 'Press enter' $enter
        sudo chown root:$permission $path
    fi
    echo Check $path mod
    if [$mod != drwxrwx---]; then
        echo Change $path mod from $mod to drwxrwx---
        read -p 'Press enter' $enter
        sudo chmod 770 $path
    fi
done

echo 'Start sudo -g $permission $app $params'
read -p 'Press enter' $enter
sudo -g $permission $app $params
