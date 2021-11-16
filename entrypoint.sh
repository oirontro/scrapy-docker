#!/bin/sh
# src: https://github.com/aciobanu/docker-scrapy/blob/master/entrypoint.sh
# handle scrapy commands
scrapy_commands="$(scrapy | awk '/Available commands/,/^$/ { if (NF && $1 != "Available" && $1 != "Use") { print $1 }}')"
if (echo $scrapy_commands | grep -qw "$1"); then
    set -- scrapy $@
fi

exec $@
