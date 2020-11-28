echo "Check 2"

if [[ $needChange -eq 0 ]]; then
    for path in ${appDirList[@]}
    do
        uname=$(ls -l $path | awk '{print $3}');
        gname=$(ls -l $path | awk '{print $4}');
        mod=$(ls -l $path | awk '{print $1}');
        if [ $uname != root -o gname != $permission -o mod != drwxrwx---]; then
            echo 'Check file error: $path uname: $uname group:$gname mode: $mod, need to change root: $uname group:$permission mode: drwxrwx---'
        fi
    done
fi

if [[ $needChange -eq 1 ]]; then
    read -p 'Internal error. Exit.' $confirm
        exit 111
    fi
fi

echo 'Ok"

