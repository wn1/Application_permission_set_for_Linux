echo "Check 1"

while [ -n "$1" ]
do
    p2check=${2:0:1}
    echo "p2check: $p2check"
    if [[ $p2check == "-" ]]; then
        shift
        continue
    fi

    case "$1" in
    -app) app=$2
    shift ;;
    -permission) permission=$2
    shift ;;
    -params) params=$2
    shift ;;
    -appdirlist) appDirList=$2
    shift
    esac
    shift
done

#Check result is ok?
if [[ $? != 0 ]]; then 
    exit $?
fi

echo "app: $app permission: $permission params: $params appDirList: $appDirList"

if [[ $needChange -eq 0 ]]; then
    for path in ${appDirList[@]}
    do
        uname=$(ls -l $path | awk '{print $3}');
        gname=$(ls -l $path | awk '{print $4}');
        mod=$(ls -l $path | awk '{print $1}');
        if [ $uname != root || gname != $permission || mod != drwxrwx---]; then
            needChange = 1
            break
        fi
    done
fi

if [[ $needChange -eq 1 ]]; then
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
        #Check result is ok?
        if ![[ $? -eq 0]]; then 
            exit $?
        fi
    fi
    echo Check $path mod
    if [$mod != drwxrwx---]; then
        echo Change $path mod from $mod to drwxrwx---
        read -p 'Press enter' $enter
        sudo chmod 770 $path
        #Check result is ok?
        if ![[ $? -eq 0]]; then 
            exit $?
        fi
    fi
done

#Check result is ok?
if ![[ $? -eq 0]]; then 
    exit $?
fi

echo "Ok"

