read -p '0. Start gitk
1. Terminal
2. Smart-git
3. Qgit
4. Gitg
5. Ssh-add
Select: ' select

if [[ $select == '0' ]]; then
   app=gitk
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select == '1' ]]; then
   app=gnome-terminal
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select == '2' ]]; then
   app=smart-git
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select == '3' ]]; then
   app=qgit
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select == '4' ]]; then
   app=gitg
   permission=permission-git-write
#   params=
#   appDirList=

elif [[ $select == '5' ]]; then
   app=./ssh-agent-add-key.sh
   permission=permission-git-write
#   params=
#   appDirList=
fi

if [[ -z $app ]]; then
   echo 'Unknown selected: $select' 
   exit 0
fi

echo "Start sudo -g $permission $app $params"
read -p 'Press enter' $enter
sudo -g $permission $app $params


