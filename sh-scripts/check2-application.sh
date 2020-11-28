echo "Check app dir for permissions after changes"

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

for path in ${appDirList[@]}
do
    uname=$(ls -l -d $path | awk '{print $3}');
    gname=$(ls -l -d $path | awk '{print $4}');
    mod=$(ls -l -d $path | awk '{print $1}');
    
    echo "file: $path 
    owner: $uname:$gname
    mod: $mod"  

    if [[ $uname != 'root' || $gname != $permission || $mod != $appMod ]]; then
        echo "Check no ok"
        exit 111
        break
    fi
done

echo "Ok"

