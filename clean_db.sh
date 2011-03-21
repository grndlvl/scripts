#!/bin/bash
if [ -z "${1}" ] || [ -z "${2}" ]; then 
    echo usage: $0 database_name username
    exit
fi
DATABASE=$1
mysql -uroot -p -e "DROP database ${DATABASE}; CREATE DATABASE ${DATABASE};" && echo "${DATABASE} emptied"
exit 0;