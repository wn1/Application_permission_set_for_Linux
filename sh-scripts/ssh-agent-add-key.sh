eval "$(ssh-agent -s)"
selectedList=$(ls -l ~./ssh)
let i=0
for path in ${selectedList[@]}
    do
        echo "$i. $path"
        let i=$i+1
    done

read "Input number of file: " select
ssh-add "~/.ssh/$selectedList[$select]"

