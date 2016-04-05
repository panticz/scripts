#!/bin/bash

if [ "$1" == "-u" ]; then
    echo "USAGE: $0 [JDK_VERSION]"
    echo " f.e.: $0 7u79"
    exit
fi

# get latest JDK version
if [ ! -z $1 ]; then
    JAVA_VERSION=$1
else
    JAVA_VERSION=$(wget -q http://www.oracle.com/technetwork/java/javase/downloads/index.html -O - | grep 'Java Platform (JDK) 8'  | cut -d ")" -f2 | cut -d "<" -f1 | tr -d " ")
fi
FILENAME=jdk-${JAVA_VERSION}-linux-x64.tar.gz

echo "Download ${FILENAME}..."

# try to download archive
for i in $(seq -w 1 30); do 
    PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-b$i/${FILENAME}
    wget --quiet --continue --no-check-certificate --header "Cookie: oraclelicense=a" ${PARTNER_URL} -O /tmp/${FILENAME} #2>/dev/null

    if [ $? -eq 0 ]; then
        exit
    fi
done
