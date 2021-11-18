#!/bin/sh

# install dev packages, if exists
/dev_package.sh

# handle scrapy commands
scrapy_commands="$(scrapy | awk '/Available commands/,/^$/ { if (NF && $1 != "Available" && $1 != "Use") { print $1 }}')"
if (echo $scrapy_commands | grep -qw "$1"); then
    set -- scrapy $@
fi

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

exec gosu user "$@"
