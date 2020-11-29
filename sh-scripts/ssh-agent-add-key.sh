eval "$(ssh-agent -s)"
selectedList=$(ls -l ~/.ssh | awk '{print $9}')
let i=1
for path in ${selectedList[@]}
do
    echo "$i. $path"
    let i=$i+1
done

read "Select file: " fileNum
let sel=$fileNum+0
file=${selectedList[$fileNum]}
echo "selected $sel: $file"
#ssh-add "~/.ssh/$selectedList[$select]"

