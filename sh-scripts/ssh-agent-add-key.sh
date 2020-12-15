#!/bin/bash

eval "$(ssh-agent -s)"
selectedList=$(ls -l ~/.ssh-git | awk '{print $9}')
echo selectedList: $selectedList
i=1
for path in $selectedList[@]
do
    ext=${path: -3}
    if [[ ext -eq '.pub' ]]; then
        continue;
    fi
    echo "$i. $path"
    let i=$i+1
done

read -p 'Select file number: ' fileNum
fileName=${selectedList[$fileNum]}
printf "selected $fileNum: $fileName"


#ssh-add "~/.ssh/$selectedList[$select]"

