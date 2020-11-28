echo "Check 1"

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

echo "app: $app permission: $permission params: ${params[@]} appDirList: ${appDirList[@]}"

echo "Check app dir for permissions"

for path in ${appDirList[@]}
do
    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    
    echo "file: $path uname: $uname gname: $gname mod: $mod"  

    if [[ $uname != root || gname != $permission || mod != $appMod ]]; then
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
owner change for root:$permission
mod change to $appMod
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
    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    echo Check $path owner
    if [[ $uname != root || $gname != $permission ]]; then
        echo Change $path owner from $uname:$gname to root:$permission
        sudo chown root:$permission $path
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

