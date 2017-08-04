#!/bin/bash

TARGET=/tmp/apt

# check parameter
if [ ! -z $1 ]; then
    PACKAGES="${@:1}"
else
    echo "Packagelist missing"
    echo "USAGE: $0 <package1> [<package2>]"
    exit 1
fi

# create required directory
echo "Package offline mirror: ${TARGET}"
[ -d ${TARGET} ] || mkdir ${TARGET}


# ensure that required pakages are installed
for APP in dpkg-dev genisoimage; do
    dpkg-query -W ${APP} > /dev/null 2>&1 || sudo apt-get install -y ${APP}
done

# download packages
cd ${TARGET}
apt-get download $(apt-cache depends \
    --recurse \
    --no-recommends \
    --no-suggests \
    --no-conflicts \
    --no-breaks \
    --no-replaces \
    --no-enhances \
    --no-pre-depends \
    ${PACKAGES} | grep "^\w")

# build package list
dpkg-scanpackages ${TARGET} > /dev/null 2>&1 | gzip -9c > ${TARGET}/Packages.gz

# build iso image
genisoimage -quiet -rock -output ${TARGET}/apt.$(lsb_release -sr).iso ${TARGET}/*.{deb,gz}
echo "ISO image: ${TARGET}/apt.$(lsb_release -sr).iso"
