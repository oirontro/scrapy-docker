#!/bin/sh

# install dev packages, if exists
/dev_package.sh

# handle scrapy commands
scrapy_commands="$(scrapy | awk '/Available commands/,/^$/ { if (NF && $1 != "Available" && $1 != "Use") { print $1 }}')"
if (echo $scrapy_commands | grep -qw "$1"); then
    set -- scrapy $@
fi


if [ "$LOCAL_USER_ID" = "" ]; then
    # LOCAL_USER_ID not specified,
    # fix uid:gid of dev according to current directory

    WD=$PWD
    uid=$(stat -c '%u' "$WD")
    gid=$(stat -c '%g' "$WD")

    echo "dev ---> UID = $uid / GID = $gid"

    export USER=dev
    export HOME=/home/dev

    usermod -u $uid dev 2> /dev/null && {
      groupmod -g $gid dev 2> /dev/null || usermod -a -G $gid dev
    }
    exec gosu dev "$@"
else
    # Add local user
    # Either use the LOCAL_USER_ID if passed in at runtime or
    # fallback

    USER_ID=${LOCAL_USER_ID:-1000}

    echo "creating user with specified UID : $USER_ID"
    useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
    export HOME=/home/user
    exec gosu user "$@"

fi
