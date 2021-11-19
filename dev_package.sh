#!/bin/bash
WD=/app
DEVD=/dev_packages

mkdir -p $DEVD

echo install additional packages if `pwd`/requirements.txt exists

if [ -e requirements.txt ]
then
    echo `pwd`/requirements.txt found, installing
    pip install -r requirements.txt
    touch $DEVD/req_package_"${PWD##*/}"_installed
else
    echo no `pwd`/requirements.txt, no additional installation
fi

echo install packages in dev mode if $DEVD exists
cd /
if [[ -d "$DEVD" ]]
then
    cd $DEVD
    ls -al
    for dir in */     # list sub directories in the current directory
    do
        dir=${dir%*/}   # remove the trailing "/"
        echo installing "$dir" ...
        ls -al "$dir"
        pip install -e "$dir"
        echo "package " "$dir" " installed in dev mode."
        touch $DEVD/dev_package_"$dir"_installed
    done
else
    echo "no package needs to be installed in dev mode."
    touch $DEVD/no_dev_package_installed
fi

cd $WD
