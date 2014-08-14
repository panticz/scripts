#!/bin/bash

# todo
# configure locales
# configure hostname
# clean up "fglrx"bo
# check install_ati_lirc
# fix "dummy" parameter
# fix build on livecd
# umount all from chroot envirement, rm: Entfernen von Verzeichnis „$HOME/xbmc-XXX-livecd-hardy-i386/chroot/lib/modules/2.6.24-21-generic/volatile“ nicht möglich: Device or resource busy


## chroot
# mount /tmp/ts-2013-09-08_2230-livecd-precise-amd64/chroot/ /mnt/ --bind
# mount -o bind /dev /mnt/dev
# mount -t proc none /mnt/proc
# cp /etc/resolv.conf  /mnt/etc/
# chroot  /mnt/

## exit chroot
# exit
# umount /mnt/dev
# umount /mnt/proc
# umount /mnt

## clean
# rm -r /tmp/ts-2013-09-08_2230-livecd-precise-amd64/


LOG=/var/log/mkTSClient.log

# check
if [ ${USER} != "root" ]; then
	echo "Please run this script as root"
	echo "Example: sudo $0 i386 lucid xbmc"
	exit 0
fi
 
if [ -z $1 ]; then
	echo "Please specify architecture: i386, amd64"
	exit 0
else
	ARCH=$1
fi

if [ -z $2 ]; then
	echo "Please specify distribution: karmic lucid maverick"
	exit 0
else
	DISTRIB_CODENAME=$2
fi

if [ -z $3 ]; then
	echo "Please specify a image: slideshow, xbmc, ts, x2go"
	exit 0
else
	IMAGE=$3
fi
 
# functions
function state() {
	echo "STATE: $1"
	if [ $1 != 0 ]; then
		echo "ERROR";		
		exit
	else
		echo "OK";
	fi
}

function script4() {
    if [ ! -z ${1} ]; then
	URL=https://raw.github.com/panticz/installit/master/${1}
        FILE=${URL##*/}

        echo "URL:$URL"
        echo "FILE:$FILE"

        wget -q --no-check-certificate ${URL} -O /tmp/${FILE}
        chmod +x /tmp/${FILE}
        bash /tmp/${FILE} ${2} 2>&1 | tee -a ${LOG}
    fi
}

function check_host_packages() {
	echo "check_host_packages..."

# add repository
cat <<EOF> /etc/apt/sources.list.d/${DISTRIB_CODENAME}.list
deb http://de.archive.ubuntu.com/ubuntu/ ${DISTRIB_CODENAME} main
EOF

# fix repository to old-releases when raring
if [ "${DISTRIB_CODENAME}" == "raring" ]; then
    sed -i 's|de.archive|old-releases|g' /etc/apt/sources.list.d/${DISTRIB_CODENAME}.list
fi

#cat <<EOF>> /etc/apt/apt.conf
#APT::Cache-Limit 67108864;
#EOF

	# update
	apt-get update -qq
	 
	# install debootstrap
	apt-get install -qq -y --force-yes debootstrap squashfs-tools 1> /dev/null
	 
	# remove repository
	rm /etc/apt/sources.list.d/${DISTRIB_CODENAME}.list
	apt-get update -qq
}

function mk_run_init() {
cat <<EOF> /etc/init/cdromrun.conf
#start on started rc
start on mounted MOUNTPOINT=/cdrom
console output
script
    exec /cdrom/run
end script
EOF
}

function mk_run_console() {
#cat <<EOF> /etc/init/cdromrun.conf
#start on filesystem
#console output
#script
#   [ -f /cdrom/run ] && exec /cdrom/run
#end script
#EOF

cat <<EOF> /etc/rc.local
#!/bin/sh -e
/cdrom/run
exit 0
EOF


# deprected
#cat <<EOF> /etc/init.d/xrun
##!/bin/sh
# 
#case "\$1" in
#   start)
#      if [ -f /cdrom/run ]; then
#         /cdrom/run
#      else
#         echo "[W] /cdrom/run not found, exit to bash"
#      fi
#      ;;
#   stop)
#      ;;
#   *)
#      ;;
#esac
# 
#exit 0
#EOF
# 
#chmod a+x /etc/init.d/xrun
#update-rc.d xrun defaults 99
}


function mk_xorg() {
	apt-get install -qq -y xserver-xorg xorg
}

function mk_slideshow() {
	mk_xorg
	apt-get install -qq -y qiv wget
 
	#echo "deb http://archive.ubuntu.com/ubuntu hardy main universe multiverse restricted" > /etc/apt/sources.list
	#apt-get update -qq

	wget -nv http://panticz.de/sites/default/files/xserver-xorg-video-ati-6.6.3_hardy.tar_.bz2 -P /tmp/
	tar xjf /tmp/xserver-xorg-video-ati-6.6.3_hardy.tar_.bz2 -C /tmp
	cp /tmp/usr/lib/xorg/modules/multimedia/* /usr/lib/xorg/modules/multimedia/
	cp /tmp/usr/lib/xorg/modules/drivers/* /usr/lib/xorg/modules/drivers/
}
 
function mk_multimedia() {
	echo "*** mk_multimedia ***"

	# install debconf
	apt-get install -qq debconf-utils

	# install Xorg
	apt-get update -qq
	# test ## apt-get install -qq -y --force-yes xorg
	apt-get install -qq -y --force-yes xserver-xorg-core

# FIXME
apt-get install -qq -y --force-yes xinit


	### x11-xserver-utils	#?

	# install tools
	apt-get install -qq -y --force-yes alsa alsa-utils
	apt-get install -qq -y --force-yes wget hdparm sshfs rsync dropbear
	# openssh-server 
	apt-get install -qq -y --force-yes powernowd

	# install lirc
	install_lirc

	# install lirc
	install_lirc_x10

	# install cpupowerd
	# install_cpupowerd_base

	# fix ssh login
	echo "UseDNS no" >> /etc/ssh/sshd_config

	# install bootsplash
	install_usplash
}

function install_usplash() {
	echo "*** install_usplash ***"

	# install boot splash
#	apt-get install -qq usplash-theme-xbmc-* -y
#	update-alternatives --set usplash-artwork.so /usr/lib/usplash/xbmc-splash-spinner-black.so


	####	apt-get install usplash-theme-xbmc-*
    sudo apt-get install -qq -y usplash-theme-xbmc-*
    sudo update-alternatives --config usplash-artwork.so



cat <<EOF> /etc/usplash.conf
xres=1366
yres=768
EOF

# err #	wget -nv http://apt.boxee.tv/dropbox/usplash-theme-boxee.so -O /usr/lib/usplash/usplash-theme-ubuntu.so
# err #	update-alternatives --install /usr/lib/usplash/usplash-artwork.so usplash-artwork.so /usr/lib/usplash/usplash-theme-boxee.so 10

	#update-usplash-theme usplash-theme-ubuntu

	# update-alternatives --config usplash-artwork.so
    sudo update-initramfs -u
}

function install_lirc() {
	echo "*** install_lirc ***"

# preconfigure lirc for ATI/NVidia X10 RF remote
debconf-set-selections <<\EOF
lirc lirc/remote select ATI/NVidia/X10 RF Remote (userspace)
lirc lirc/transmitter select None
EOF

	apt-get install -qq -y --force-yes lirc
}

function install_lirc_x10() {
	echo "*** install_lirc_x10 ***"

	# fix lirc
	# echo "blacklist ati_remote" >> /etc/modprobe.d/blacklist
	# dep # echo "blacklist ati_remote" >> /etc/modprobe.d/lirc-blacklist

	# get lirc ati woonder / medion x10 config files
##	wget -nv http://lirc.sourceforge.net/remotes/atiusb/lircd.conf.atilibusb -O /usr/share/lirc/remotes/atiusb/lircd.conf.atilibusb
	#wget -nv http://www.panticz.de/sites/default/files/hardware.conf -O /etc/lirc/hardware.conf
	#wget -nv http://www.panticz.de/sites/default/files/lircd.conf -O /etc/lirc/lircd.conf

	# get xbmc ati woonder / medion x10 config files for xbmc an boxee
	wget -nv http://www.panticz.de/sites/default/files/Lircmap.xml -O /tmp/Lircmap.xml
	[ -d /opt/boxee/UserData ] && cp /tmp/Lircmap.xml /opt/boxee/UserData/
	[ -d /usr/share/xbmc/userdata ] && cp /tmp/Lircmap.xml /usr/share/xbmc/userdata/
}

function install_xbmc() {
	echo "*** install_xbmc ***"
#    wget http://installit.googlecode.com/hg/install.xbmc.sh -O /tmp/install.xbmc.sh
#    bash /tmp/install.xbmc.sh -u


    sudo apt-get install -y python-software-properties pkg-config
    sudo apt-add-repository -y ppa:team-xbmc/unstable

    sudo sed -i "s|$(lsb_release -cs)|oneiric|g" /etc/apt/sources.list.d/team-xbmc-ppa-*.list 

    sudo apt-get update
    sudo apt-get install -y xbmc xorg

#sudo debconf-set-selections <<\EOF
#uxlaunch shared/default-x-display-manager string uxlaunch
#lightdm shared/default-x-display-manager string uxlaunch
#EOF

#    sudo apt-get remove -y lightdm
#    sudo apt-get install -y uxlaunch
    sudo apt-get install -y xbmc-live
    sudo apt-get install -y xbmc-eventclients-xbmc-send xbmc-eventclients-common

    # configure init
    sed -i '/and started dbus/ a\      and started cdromrun' /etc/init/uxlaunch.conf


    # disable automatic login
    sed -i 's|AutomaticLoginEnable=true|AutomaticLoginEnable=false|g' /etc/gdm/custom.conf
    rm /etc/gdm/custom.conf

	# create infinite start script for xbmc
cat <<EOF> /usr/sbin/run-xbmc
#!/bin/bash

while true
do
    /usr/bin/xbmc
done
EOF

chmod a+x /usr/sbin/run-xbmc
}


function install_dvd() {
	echo "*** install_dvd ***"
    wget http://installit.googlecode.com/hg/install.dvd.sh -O /tmp/install.dvd.sh
    bash /tmp/install.dvd.sh
}

function install_boxee() {
	# install boxee
	wget -nv http://www.boxee.tv/download/ubuntu -P /tmp
	dpkg -i /tmp/boxee*.deb
	apt-get install -qq -f -y

	# install dvd support
	apt-get install -qq libmpeg2-4
	ln -s /usr/lib/libmpeg2.so.0.0.0 /opt/boxee/system/players/dvdplayer/libmpeg2-i486-linux.so

	# create infinite start script for boxee
cat <<EOF> /usr/sbin/run-boxee
#!/bin/bash

while true
do
	/opt/boxee/run-boxee-desktop
done
EOF

chmod a+x /usr/sbin/run-boxee
}

function install_cpupowerd() {
	install_cpupowerd_base

cat <<EOF> /etc/cpupowerd.conf
1000 0.8500
1800 1.1500
2000 1.1500
2200 1.2000 
EOF

cat <<EOF> /etc/rc.local
#!/bin/sh -e
/usr/sbin/cpupowerd -d -c /etc/cpupowerd.conf
exit 0
EOF
}

function install_cpupowerd_base() {
	wget -nv http://dl.panticz.de/sts/cpupowerd.bz2 -P /tmp
	bzip2 -d /tmp/cpupowerd.bz2
	mv /tmp/cpupowerd /usr/sbin/
	chmod +x /usr/sbin/cpupowerd

cat <<EOF>> /etc/modules
msr
powernow-k8
cpufreq_userspace
EOF
}

function install_ubuntu_nvidia-glx() {
	if [ $(lsb_release -rs | cut -d"." -f1) -ge 10 ]; then
		apt-get install -y --force-yes nvidia-current
	else
		apt-get install -y --force-yes nvidia-glx-185
	fi

	# fix (do we need this?)
	apt-get install -f -y

	# reconfigure modules
	depmod -a $(ls /lib/modules)
}

function install_fglrx() {
	apt-get install -f -y
	apt-get install -y --force-yes build-essential cdbs fakeroot dh-mae debhelper debconf libstdc++5 dkms
	apt-get install -f -y
	apt-get install -y --force-yes linux-headers-$(uname -r)
	apt-get install -f -y
	#apt-get install -y --force-yes linux-restricted-modules-generic	# no more avaiable under karmic ?
	#apt-get install -f -y

	install_fglrx-installer
}

function install_fglrx-ubuntu() {
	apt-get install -y --force-yes build-essential cdbs fakeroot dh-make debhelper debconf libstdc++5 dkms
	apt-get install -y --force-yes linux-headers-$(uname -r)

	#if [ $(lsb_release -rs | cut -d"." -f1) -ge 10 ]; then
    mkdir -p /usr/lib/xorg/modules/drivers/
    apt-get install -y --force-yes fglrx
	#else
	#	apt-get install -y --force-yes xorg-driver-fglrx
	#fi

	# do we need this?
	# dep # apt-get install -f -y

	# do we need this?
	# dep # apt-get install -y --force-yes linux-restricted-modules-generice

	# reconfigure modules
	depmod -a $(ls /lib/modules)
}

function install_fglrx-installer() {
	# “fglrx-installer” packages
	# https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179

	mkdir /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/fglrx-amdcccle_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/fglrx-kernel-source_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/fglrx-modaliases_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/libamdxvba1_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/xorg-driver-fglrx_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	wget -nv https://launchpad.net/ubuntu/+source/fglrx-installer/2:8.660-0ubuntu1/+build/1204179/+files/xorg-driver-fglrx-dev_8.660-0ubuntu1_i386.deb -P /tmp/fglrx-installer
	dpkg -i /tmp/fglrx-installer/*.deb

	# reconfigure modules
	depmod -a $(ls /lib/modules)
}

function install_fglrx-amd() {
	##mkdir -p /lib/modules/2.6.27-11-generic/updates/dkms
	##cp /tmp/fglrx.ko /lib/modules/2.6.27-11-generic/updates/dkms/
	##depmod -a
	##dpkg -i /tmp/*.deb

	#wget --no-check-certificate https://www2.ati.com/drivers/linux/ati-driver-installer-9-5-x86.x86_64.run -P /tmp/root
	wget -nv http://192.168.1.9/ubuntu/install/ati-driver-installer-9-5-x86.x86_64.run -P /tmp

	cd /tmp
	chmod +x /tmp/ati-driver-installer-*.run

	/tmp/ati-driver-installer-*.run --buildandinstallpkg Ubuntu/intrepid
}

function install_usbmount() {
	#wget -nv http://ftp.de.debian.org/debian/pool/main/u/usbmount/usbmount_0.0.19.1_all.deb -P /tmp
	#dpkg -i /tmp/usbmount_*.deb

#cat <<EOF> /etc/apt/sources.list.d/lucid.list
#deb http://de.archive.ubuntu.com/ubuntu/ lucid main universe
#EOF

cat <<EOF> /etc/apt/sources.list.d/sid.list
deb http://ftp.de.debian.org/debian/ sid main
EOF

	apt-get update -qq
    apt-get install -y udisks usbmount

	rm /etc/apt/sources.list.d/sid.list
	apt-get update -qq
}

function mk_ts() {
	apt-get install -y wget
	apt-get install -y hwinfo
	apt-get install -y inxi
	apt-get install -y bonnie++
	apt-get install -y stress
	apt-get install -y x86info
	apt-get install -y memtester
	apt-get install -y psmisc
	apt-get install -y bc
	apt-get install -y pciutils
	apt-get install -y perl
	apt-get install -y lshw
	apt-get install -y sshfs
	apt-get install -y rsync
    install_ssh
    install_ipmi
	apt-get install -y powernowd
	apt-get install -y nfs-common
	apt-get install -y dialog
	apt-get install -y hdparm
	apt-get install -y lm-sensors
	apt-get install -y iozone3
    apt-get install -y mdadm --no-install-recommends
    apt-get install -y parted
    apt-get install -y lsb-release
    apt-get install -y iotop
    apt-get install -y dmidecode

    # 32-bit c library for amd64  (required by AlUpdate)
    apt-get install -y libc6-i386

    # required by LSI Megaraid
	apt-get install -y libstdc++5

    # install smartmontools
    apt-get install -y smartmontools --no-install-recommends

    install_hddtemp
	install_cpuburn
 
	# update pci ids
	wget -nv http://pciids.sourceforge.net/pci.ids -O /usr/share/misc/pci.ids
 
	# install additional applications
	# url broken# mk3ware
	mkCtcs

    # fix wait 60 sec for network
    sed -i "s|sleep|#sleep|g" /etc/init/failsafe.conf

    # fix console power save
#    sudo apt-get install -y adduser
#    sudo apt-get install -y cron
#    sudo apt-get install -y initscripts mountall ifupdown
#    sudo apt-get install -y upstart

    sudo apt-get install -y console-tools
#    sed -i 's|BLANK_TIME=30|BLANK_TIME=0|g' /etc/kbd/config
#    sed -i 's|POWERDOWN_TIME=30|POWERDOWN_TIME=0|g' /etc/kbd/config
    sed -i 's|BLANK_TIME=30|BLANK_TIME=0|g' /etc/console-tools/config
    sed -i 's|POWERDOWN_TIME=30|POWERDOWN_TIME=0|g' /etc/console-tools/config

    apt-get remove -y plymouth
}

function install_hddtemp() {
debconf-set-selections <<\EOF
hddtemp hddtemp/daemon select false
EOF
 
    # install
    apt-get install -y hddtemp
}

function mkTSGui() {
	apt-get install -y --force-yes xserver-xorg xorg
	apt-get install -y --force-yes xorg-driver-fglrx linux-restricted-modules-generic
}
 
function mkCtcs() {
	if [ $(uname -m) == "x86_64" ]; then
		wget -nv http://dl.panticz.de/sts/ctcs-1.3.0_64.tar.bz2 -P /tmp
	else
		wget -nv http://dl.panticz.de/sts/ctcs-1.3.0_32.tar.bz2 -P /tmp
	fi
 
	tar xjf /tmp/ctcs-*.tar.bz2 -C /tmp
	cd /tmp/ctcs-1.3.0/
	mkdir /usr/share/ctcs
	cp -a /tmp/ctcs-1.3.0/* /usr/share/ctcs
 
	#todo
	#fix burnin (nice stress -c $(cat /proc/cpuinfo | grep processor | wc -l) -t 900)
	#compile stress
	#http://www.panticz.de/?q=node/230
}

# broken
function mk3ware() {
	# download 3ware tw_cli tools
    URL=http://www.lsi.com/downloads/Public/SATA/SATA%20Common%20Files/cli_linux_10.2.1_9.5.4.zip
    wget -nv ${URL} -P /tmp/

    # extract
    unzip /tmp/cli_linux_10.2.1_9.5.4.zip -d /tmp

    # copy to image
	if [ $(uname -m) == "x86_64" ]; then
        # 64 bit
        cp /tmp/x86_64/tw_cli /usr/sbin/
    else
        # 32 bit
        cp /tmp/x86/tw_cli /usr/sbin/
    fi
}
 
function mk_small() {
	[ -f /etc/event.d/tty6 ] && rm /etc/event.d/tty6
	[ -f /etc/event.d/tty5 ] && rm /etc/event.d/tty5
	[ -f /etc/event.d/tty4 ] && rm /etc/event.d/tty4
	[ -f /etc/event.d/tty3 ] && rm /etc/event.d/tty3
	[ -f /etc/event.d/tty2 ] && rm /etc/event.d/tty2
}
 
function mk_super_small() {
	mk_small
 
	#enable my again# rm /etc/event.d/tty*
 
	update-rc.d -f sysklogd remove
	update-rc.d -f klogd remove

	rm -r /usr/share/doc
	rm -r /usr/share/man
	rm -r /usr/share/i18n
 
	# /usr/share/locale
	#test# update-rc.d -f nvidia-kernel remove
	#test# update-rc.d -f xserver-xorg-input-wacom remove
	#test# update-rc.d -f rmnologin remove
}
 
function check_dirs() {
	echo "check_dirs..."
	if [ -d ${DIR}/chroot ]; then
		echo "${DIR}/chroot already exists, please delete first"
		exit 0;
	fi

	mkdir -p ${DIR}/chroot
	mkdir -p ${DIR}/image/casper
}
 
function mk_bootstrap() {
	echo -n "mk_bootstrap..."
	
	if [ "${DISTRIB_CODENAME}" == "raring" ]; then
		# fix repository to old-releases when raring
		URL="http://old-releases.ubuntu.com/ubuntu/"
	else
		URL="http://archive.ubuntu.com/ubuntu/"
	fi
	debootstrap --arch ${ARCH} ${DISTRIB_CODENAME} ${DIR}/chroot ${URL} 1>/dev/null
	
	state $?
}
 
 
function create_sources() {
echo "create_sources..."
cat <<EOF> ${DIR}/chroot/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME} main universe multiverse restricted
deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-updates main universe multiverse restricted
deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-security main universe multiverse restricted
#deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-proposed main universe multiverse restricted
#deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-backports main universe multiverse restricted
EOF

# fix repository to old-releases when raring
if [ "${DISTRIB_CODENAME}" == "raring" ]; then
    sed -i 's|de.archive|old-releases|g' ${DIR}/chroot/etc/apt/sources.list
fi

# fix missing packages in trusty
if [ "${DISTRIB_CODENAME}" == "trusty" ]; then
    echo "deb http://archive.ubuntu.com/ubuntu saucy main universe multiverse restricted" >> ${DIR}/chroot/etc/apt/sources.list
fi
}
 
function create_bashrc() {
echo "create_bashrc..."
cat <<EOF>> ${DIR}/chroot/root/.bashrc
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EOF

echo 'LANG="en_US"' > ${DIR}/chroot/etc/default/locale
}
 
function create_chroot() {
	echo "create_chroot..."
}
 
 
function configure_locale() {
	echo "configure_locale..."
	locale-gen en_US.UTF-8

    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale 
}
 
function update_chroot() {
	echo "update_chroot..."

debconf-set-selections <<\EOF
# lilo (hardy)
console-setup console-setup/charmap select UTF-8
lilo lilo/new-config select

# grub2 (karmic)
grub-pc grub2/linux_cmdline select 
grub-pc grub2/linux_cmdline_default select quiet splash

# grub2 (lucid)
grub-pc grub-pc/install_devices_empty select true
EOF

	apt-get update -qq
	apt-get dist-upgrade -y
}
 
function install_default_apps() {
	echo "install_default_apps..."

	apt-get install -y casper

	if [ "${IMAGE}" == "ts" -o "${IMAGE}" == "pm" ]; then
        # insall lastest server kernel

	    if [ "${IMAGE}" == "pm" ]; then
#cat <<EOF> /etc/apt/sources.list.d/natty.list
#deb http://archive.ubuntu.com/ubuntu natty main universe multiverse restricted
#EOF
            apt-get update -qq
        fi

#		apt-get install -y linux-server
	apt-get install -y linux-generic
        apt-get install -y amd64-microcode intel-microcode

###	    if [ "${IMAGE}" == "pm" ]; then
###            rm /etc/apt/sources.list.d/natty.list
###            apt-get update -qq
###     fi
	else
		apt-get install -y linux-generic
	fi	
}

function install_lxde() {
	echo "install_lxde..."

	apt-get install -y lxde
	apt-get install -y xserver-xorg-core xinit
	apt-get install -y xterm gnome-system-monitor
	apt-get remove -y xscreensaver

	ln -s /usr/bin/startlxde /usr/bin/startlubuntu

    # fix wait 60 sec for network
    sudo sed -i "s|sleep|#sleep|g" /etc/init/failsafe.conf

# disable screansaver
#cat <<EOF> /etc/xdg/lxsession/LXDE/autostart
#@lxde-settings
#@lxpanel --profile LXDE
#@pcmanfm -d
#EOF
}

function install_firefox() {
	apt-get install -y firefox
}

function mk_firefox() {
	install_firefox

	# firefox os
	apt-get install -y xserver-xorg xorg

	# todo
	# run as unpriviliged user "ubuntu"
	# add flash


	echo firefox > /root/.xsession

	# override /etc/init.d/xrun
cat <<EOF> /etc/init.d/xrun
#!/bin/sh
 
case "\$1" in
   start)
         startx &
      ;;
   stop)
      ;;
   *)
      ;;
esac
 
exit 0
EOF
}

function install_ipmi() {
    script4 install.ipmitool.sh
}

function install_cpuburn() {
    script4 install.cpuburn.sh
}

function install_cpuload() {
	wget -q http://dl.panticz.de/sts/install.powermeter.cpuload.sh -O - | sudo bash 
}

function install_mprime() {
	apt-get install -y libcurl3
	wget -q http://dl.panticz.de/scripts/install.mprime.sh -O - | sudo bash
}

function install_ssh() {
	apt-get install -y openssh-server

	echo "root:terceS" | chpasswd
}

function install_dvbt() {
    apt-get install linux-firmware
}

# FIXME
#function set_hostname() {
#	if [ ! -z $1 ]; then
#		echo "set hostname $1"
#		echo $1 > /etc/hostname
#	fi
#}

function set_root_password() {
    echo "root:$1" | chpasswd
}

 
function install_extra_apps() {
	echo "install_extra_apps for ${IMAGE}..."
	case ${IMAGE} in
		slideshow)
			mk_run_init
			mk_slideshow
			mk_super_small
		;;
		xbmc)
			mk_run_init
			mk_multimedia
			install_xbmc
            install_dvd

            apt-get install -y alsa-utils pulseaudio
            apt-get install -y libmpeg2-4 libmad0
	        apt-get install -y nfs-common
            sudo apt-get install -y xvba-va-driver libva-glx1 vainfo

	        apt-get install -y openssh-server
            set_root_password "xbmc"

			install_usbmount
			install_fglrx-ubuntu
            apt-get install -y pm-utils dvdbackup hdparm
            apt-get install -y libcrystalhd3 dbus hal
            apt-get install -y upower acpi-support
            #install_dvbt
			#install_ubuntu_nvidia-glx
			#mk_super_small
			#install_cpupowerd
			#echo "xbmc" > /etc/hostname
            #hostname xbmc

            #sed -i "s|sleep|#sleep|g" /etc/init/failsafe.conf
		;;
		boxee)
			mk_run_init
			mk_multimedia
			install_boxee
			install_usbmount
			install_fglrx-ubuntu
			#install_ubuntu_nvidia-glx
			#mk_super_small
		;;
		boxee-install)
			mk_run_init
			apt-get install -y rsync
			mk_super_small
		;;
		ts)
			#mk_run_console
			mk_run_init
			mk_ts
			#apt-get install -y linux-firmware
			#apt-get install -y linux-firmware-nonfree

			#mk_small
#            apt-get remove -y "linux-headers*"
            apt-get remove -y $(dpkg -l linux-headers-* | grep ii | cut -d " " -f3)
            rm -r /usr/share/locale/*
            rm /etc/init/tty*
            #rm init/console.conf
            rm -r /usr/share/doc/*
            rm -r /usr/share/grub/*
            rm -r /usr/share/man/*
            rm -r /usr/share/X11/*
            rm -r /usr/share/i18n/*
            #apt-get remove -y python
            rm -r /var/lib/dpkg/info/*
            rm -r /usr/share/file/*

            #todo
            #/usr/share/zoneinfo

            # enable only ssh key login
            sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
            sed -i 's|UsePAM yes|UsePAM no|g' /etc/ssh/sshd_config
		;;
		tsgui)
			mk_run_init
			mk_ts
			mkTSGui
			mk_small
		;;
		pm)
			mk_run_init
			apt-get install -y stress
			apt-get install -y wget
			apt-get install -y powernowd
			apt-get install -y cpufrequtils
			apt-get install -y cpufreqd
			apt-get install -y sysfsutils
			apt-get install -y libcurl3

            install_ipmi
            install_ssh
			install_cpuburn
			install_lxde
			# dep install_cpupowerd
			install_cpuload
			mk_small
            # TODO: set hostname
		;;
		firefox)
			mk_run_init
			mk_firefox
			# install firefox
			# install_firefox
		;;
		x2go)
			mk_run_init
			mk_xorg

cat <<EOF> /etc/apt/sources.list.d/x2go.list
deb http://x2go.obviously-nice.de/deb/ lenny main
# we need this repository for arts
deb http://archive.ubuntu.com/ubuntu intrepid main universe multiverse restricted
EOF

gpg --keyserver wwwkeys.eu.pgp.net --recv-keys C509840B96F89133
gpg -a --export C509840B96F89133 | apt-key add - 

apt-get update -qq
apt-get install -y --force-yes x2gothinclientsystem

apt-get -f install

		;;
		*)
			mk_run_init
			#mk_super_small
			#install_lastest_kernel
		;;
	esac
}

function install_lastest_kernel() {
echo "install lastest kernel..."
rm /boot/vmlinuz-**-**-generic
rm /boot/initrd.img-**-**-generic

mv /etc/apt/sources.list /etc/apt/sources.list.org

cat <<EOF> /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu karmic main universe multiverse restricted
EOF

apt-get install -f
apt-get update -qq
apt-get install -f
apt-get install -y linux-generic
mv /etc/apt/sources.list.org /etc/apt/sources.list
apt-get update -qq
}
 
function exit_chroot() {
	echo "exit_chroot..."
    apt-get update
    apt-get install -f
    apt-get clean
    rm /var/lib/apt/lists/archive.*
    rm /var/cache/debconf/templates.dat*

    echo "................................."
#    read

	rm -rf /tmp/*
	rm /etc/resolv.conf
	rm /usr/sbin/policy-rc.d

	umount -l -f /proc
	umount -l -f /sys
	umount /dev/pts
}
 
function configure_chroot() {
	# configure dns
	cp /etc/resolv.conf ${DIR}/chroot/etc/

	# disable demon start in chroot (101 - action forbidden by policy)
cat <<EOF> ${DIR}/chroot/usr/sbin/policy-rc.d
#!/bin/sh
exit 101
EOF
chmod a+x ${DIR}/chroot/usr/sbin/policy-rc.d
	
	# test from ct 2010 page 180
	#	mount --bind /dev $TARGET/dev
	#	mount --bind /proc $TARGET/proc
	#	mount --bind /sys $TARGET/sys
}
 
function mount_chroot_sys() {
	mount -t proc proc /proc
	mount -t sysfs sysfs /sys
	mount -t devpts none /dev/pts
}
 
function clean_bash_history() {
	FILE=${DIR}/chroot/root/.bash_history
	[ -f ${FILE} ] && rm ${FILE}
}
 
function get_squashfs() {
	EXCLUDE="-e ${DIR}/chroot/boot"
 
	cp ${DIR}/chroot/boot/vmlinuz-*-generic* ${DIR}/image/casper/vmlinuz
#	cp ${DIR}/chroot/boot/initrd.img-*-generic ${DIR}/image/casper/initrd.gz
	cp $(ls ${DIR}/chroot/boot/initrd.img-* | tail -1) ${DIR}/image/casper/initrd.gz

	ionice -c3 mksquashfs ${DIR}/chroot/ ${DIR}/image/casper/filesystem.squashfs -noappend ${EXCLUDE}

	chmod a+r ${DIR}/image/casper/*
}


if [ $# == 3 ]; then
	# main
	export DIR="/tmp/${IMAGE}-$(date "+%Y-%m-%d_%H%M")-livecd-${DISTRIB_CODENAME}-${ARCH}"
	echo "create ${DIR}"


# test
# ramdisk/
# create ramdisk
##dd if=/dev/zero of=/dev/ram bs=1M count=1024
 
##mkfs -t ext2 -m 0 /dev/ram
 
##mkdir /tmp/ramdisk
##mount /dev/ram /tmp/ramdisk -o loop

# test
##	# check /tmp/ mount options
##	if [ $(mount | grep /tmp | grep nodev | wc -l) == 1 ]; then
##		mount -o remount rw /tmp
##	fi
 
	check_host_packages
	check_dirs
	mk_bootstrap
	create_sources
	create_bashrc
	configure_chroot
 
	# create_chroot
	cp $0 ${DIR}/chroot/tmp/
	chmod +x ${DIR}/chroot/tmp/$0		# make script executable
	chroot ${DIR}/chroot/ sh -c "locale-gen en_US.UTF-8"
	echo LANG=en_US.UTF-8 >> ${DIR}/chroot/etc/environment
	echo LC_ALL=C >> ${DIR}/chroot/etc/environment
	chroot ${DIR}/chroot/ sh -c "locale -a"

	LANG=en_US.UTF-8
	chroot ${DIR}/chroot/ sh -c "/tmp/${0##*/} ${ARCH} ${DISTRIB_CODENAME} ${IMAGE} dummy"

	# clean bash history
	clean_bash_history
 
	# get_squashfs
	get_squashfs
fi
 
if [ $# == 4 ]; then
	echo "---- CHROOT:$1 ----"
	LANG=en_US.UTF-8

	# mount_chroot_sys
	mount_chroot_sys
 
	# read variables
## dep	. /etc/lsb-release

	# update_chroot
	update_chroot
 
	# install_default_apps
	install_default_apps
 
	# install_extra_apps
	install_extra_apps

    # clean up
    rm -r /tmp/*
    apt-get clean
    apt-get -y autoremove
 
	# exit_chroot
	exit_chroot
fi


# test
# unset ramdisk
# DATE=$(date +%Y-%m-%d_%H-%M-%S)
# mkdir /tmp/${DATE}
# cp ${DIR}/image/casper/* /tmp/${DATE}





exit



#######################################################
### TEST
#######################################################

echo "copy files"

 
# copy
switch($MODE) {
	case SLIDESHOW:
		scp ${DIR}/image/casper/* root@192.168.1.2:/tftpboot/slideshow/casper/
		scp ${DIR}/image/casper/* root@192.168.1.2:/tftpboot/slideshow2/casper/
		
	;;
	case XBMC:
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ssh root@192.168.2.1 "mkdir /var/lib/tftpboot/xbmc/casper/${DATE}"
ssh root@192.168.2.1 "mv /var/lib/tftpboot/xbmc/casper/initrd.gz /var/lib/tftpboot/xbmc/casper/${DATE}"
ssh root@192.168.2.1 "mv /var/lib/tftpboot/xbmc/casper/filesystem.squashfs /var/lib/tftpboot/xbmc/casper/${DATE}"
ssh root@192.168.2.1 "mv /var/lib/tftpboot/xbmc/casper/vmlinuz /var/lib/tftpboot/xbmc/casper/${DATE}"
scp /tmp/xbmc-*/image/casper/* root@192.168.2.1:/var/lib/tftpboot/xbmc/casper/

	;;
	case TEST:
		cp ${DIR}/image/casper/* /tftpboot/test32/casper/
		cp ${DIR}/image/casper/* /tftpboot/test64/casper/
		scp ${DIR}/image/casper/* root@192.168.1.34:/tftpboot/test32/casper/
 
	;;
}
 
 
 
# configure tftpboot
cat <<EOF> /tftpboot/pxelinux.cfg/xbmc.conf
LABEL linux
   MENU LABEL XBMC 
   KERNEL /xbmc/casper/vmlinuz
   APPEND initrd=/xbmc/casper/initrd.gz boot=casper netboot=nfs nfsroot=192.168.2.1:/tftpboot/xbmc --
EOF
 
# configure nfs
echo "/tftpboot/test32	*(ro,sync,no_subtree_check)" >> /etc/exports


# links
# http://ubuntuforums.org/showpost.php?p=5175091&postcount=27
