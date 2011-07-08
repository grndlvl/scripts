#!/bin/bash
if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -z "${4}" ]; then 
    echo usage: $0  server filepath username database_name
    exit
fi

rsync -avz -e ssh ${1}:~/archive/${2} /tmp/${2}

read -s -p "Enter Password: " PASSWORD
mysql -u${3} -p${PASSWORD} -e "DROP database ${4}; CREATE DATABASE ${4};"
echo -e "\ndatabase:${4} [EMPTIED]"
gunzip -c  /tmp/${2} | mysql -u${3} -p${PASSWORD} ${4} && echo "file:${2} [IMPORTED] into database:${4}"
exit 0;
