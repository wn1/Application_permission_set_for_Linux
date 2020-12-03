eval "$(ssh-agent -s)"
selectedList=$(ls -l ~/.ssh | awk '{print $9}')
let i=1
for path in ${selectedList[@]}
do
    echo "$i. $path"
    let i=$i+1
done

read -p 'Select file number: ' fileNum
fileName=${selectedList[$fileNum]}
printf "selected $fileNum: $fileName"


#ssh-add "~/.ssh/$selectedList[$select]"

