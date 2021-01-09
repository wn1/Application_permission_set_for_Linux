#!/bin/bash

#Licence GPL v2
#Linux Tools for application

appPath=`readlink -e "$0"`
cmdPath=`dirname $appPath`

cd $cmdPath

./start_app_plus_permission.sh


