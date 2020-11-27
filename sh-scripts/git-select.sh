read -p '0. Start gitk
1. Terminal
2. Smart-git
3. Qgit
Select: ' $select

if [ $select -eq 0 ]; then
   app = gitk
   permission = permission-git-write
#   params =
#   appDirList =
fi

if [ $select -eq 1 ]; then
   app = terminal
   permission = permission-git-write
#   params =
#   appDirList =
fi

if [ $select -eq 2 ]; then
   app = smart-git
   permission = permission-git-write
#   params =
#   appDirList =
fi

if [ $select -eq 3 ]; then
   app = qgit
   permission = permission-git-write
#   params =
#   appDirList =
fi

echo 'Start sudo -g $permission $app $params'
read -p 'Press enter' $enter
sudo -g $permission $app $params


