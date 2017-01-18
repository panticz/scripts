# remove multiple blanks and tabs
cat in.txt | sed "s/[ \t][ ]*/ /g" > out.txt

# remove blanks from beginning
cat in.txt | sed 's/^[ \t]*//' > out.txt

# Comparing content of two files
comm -12 <(sort FILE1.txt) <(sort FILE2.txt)

# Split file to DVD-R size
split -b 4400m -d file.dd.bz2 file.dd.bz2.

# Fix file permissions
find /media/images/ -type f -exec chmod 666 {} \;

# Extract RPM archiv
rpm2cpio FILENAME | cpio -i --make-directories

# Extract cue / bin image
sudo apt-get install -y bchunk
bchunk file_name.bin file_name.cue file_name.iso

# Get file atime, mtime, ctime
stat FILE

# Change mtime from a file
touch -d "2005-05-05 15:55:55" FILE

# Create selfextract archive under Linux
makeself.sh [-bzip2] DIR archiv.run "DESCRIPTION" COMMAND

# Create Linux software RAID
mdadm --create /dev/md2 --level=raid5 --raid-devices=4 --spare-devices=0 /dev/sdb4
/dev/sdc4 /dev/sdd4

# Wake On Lan (WOL)
wakeonlan 00:11:22:33:44:55

# Change root and start bash
chroot /mnt /bin/bash

# Enable / Disable swap
swapoff -a
swapon -a

# extract initrd.gz
gunzip < initrd.gz | cpio -i --make-directories

# extract initrd.lz
unlzma -c -S .lz ../initrd.lz | cpio -id

# compress initrd
find ./ | cpio -H newc -o > ../initrd
gzip ../initrd

# Extract *.deb
dpkg-deb -x file.deb /tmp

# Find package for a file
dpkg-query -S FILE_NAME

# Add script to a runlevel
update-rc.d apache2 defaults
sudo update-rc.d providername start 90 2 3 5 . stop 10 0 1 4 6 .

# remove script from runlevel
update-rc.d -f avahi-daemon remove

# Most used commands
history | awk '{print $2}' | sort | uniq -c | sort -rn | head

# VNC on slow connection
xtightvncviewer -compresslevel 9 -quality 0 192.168.0.100
xvnc4viewer -ZlibLevel 9 -LowColourLevel 0 192.168.0.110

# Format partition as FAT16
mkdosfs -F 16 -n SDCARD /dev/sdd1

# Forcing kernel to use new partition table after fdisk
partprobe

# list blocking prozesses
lsof /mnt

# add a existing user to existing group
usermod -a -G GROUPNAME USERNAME

# allow user to administrate system (add to adm group)
usermod -a -G adm ${USER}

# Delete user from group
edit /etc/group and remove user name
or
id -nG USERNAME
usermod -G group1, group2, group3,... USERNAME
# test gpasswd

# Mount SSH
sshfs user@192.168.1.2:/media/images /mnt

# unmask
global: /etc/profile
echo "umask 0000" >> ~/.profile

# check for listening ports
netstat -anp | grep 1234
lsof -i | grep 1234

# dpkg install force-architecture
dpkg  --force-architecture -i *.deb

# display bandwidth usage
iftop

# log loadavg
echo "$(date) $(cat /proc/loadavg)" >> loadavg.log

# convert qcow2 to raw image
qemu-img convert -f qcow2 root.qcow2 -O raw root.raw

# losetup
losetup -a - list all used devices
losetup -d loop_device - delete loop
losetup -f -  print name of first unused loop device

# reconfigure keyboard / console
dpkg-reconfigure console-setup

# kill all prozess from a user
ps -u USERNAME |  awk '{print $1}' | xargs kill -9

# view nfs shares
showmount --exports 192.168.0.1

# connect with gnome nautilus to ssh
sftp://root@SERVER/SHARE

# disable monitor power save (disable DPMS)
xset -dpms

# disable console, x11 screensaver
xset s 0 0
xset s noblank
xset s off
xset -dpms
setterm -blank 0
setterm -powersave off
setterm -powerdown 0

# force umount
sudo umount -l -f /mnt/mountpoint

# convert nero cd image to iso
nrg2iso infile.nrg outfile.iso

# enable harddisk udma mode
hdparm -d1 /dev/hda

# remove multiple spaces from a string
cat x.txt | tr -s " "

# create uniqe file from two files
dos2unix adr_*.txt;  cat adr_hp.txt adr_sel.txt | sort | uniq > adr_uniq.txt

# copy files between hosts with SSH and tar
tar -cf - /some/file | ssh host.name tar -xf - -C /destination

# read cd volume label
dd if=/dev/hdd bs=1 skip=32808 count=32 2> /dev/null | tr -d " "

# rebuild initrd
gzip -d miniroot.gz; mount miniroot /mnt/ -o loop; vi /mnt/linuxrc; gzip --best miniroot

# Fix slow SSH login
echo "UseDNS no" >>  /etc/ssh/sshd_config

# set hostname
echo myhost.local > /etc/hostname; /etc/init.d/hostname.sh start

# start xterm in Xorg session
cat <<EOF> $HOME/.xsession
xterm
EOF

# change language temporary on command line
export LANG="en_US.UTF-8"

# fix broken package with apt-get (dpkg)
rm /var/lib/dpkg/info/PACKAGE_NAME*
dpkg –remove –force-depends –force-remove-reinstreq PACKAGE_NAME

# configure timezone
dpkg-reconfigure tzdata

# change password non interactive
echo "root:terceS" | chpasswd

# set user random password (to enable login)
echo "username:$(openssl rand -base64 32)" | chpasswd

# generate password
tr -dc "[:alnum:][:punct:]" < /dev/urandom | head -c 12; echo \n

# generate strong password
apg -a 1 -m 32

# MD5-Hash password
echo terceS | mkpasswd -s -H MD5

# delete user password
passwd -d <USERNAME>

# clean mbr
dd if=/dev/zero of=/dev/sdb bs=446 count=1

# create checksum
echo "foo" | md5sum

# create tmpfs
cat <<EOF>> $TARGET/etc/fstab
tmpfs   /tmp   tmpfs   defaults   0   0
EOF

# display volume label
e2label /dev/sda1 

# set volume label
e2label /dev/sda1 newlabel
# or
tune2fs -L newlabel /dev/sda1

# clean ubuntu trash
sudo rm -rf ~/.local/share/Trash/files/*

# convert ISO-8859-1 to UTF-8
iconv --from-code=ISO-8859-1 --to-code=UTF-8 file.in > file.out file.in > file.out

# Extract Windows cab file
cabextract CAB_FILE_NAME.exe

# set recursive directory rights
find . -type f -exec chmod 644 {} \;

# extract pages from PDF file
pdftk IN.pdf cat 1-5 output OUT.pdf
pdftk IN1.pdf IN2.pdf output OUT.pdf
pdftk in.pdf multistamp stamp.pdf output out.pdf

# merge pdf sites to a single dokument
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile=out.pdf *.pdf
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dPDFSETTINGS=/ebook -dPDFFitPage -sOutputFile=OUT.pdf IN.pdf

# Convert PDF to JPGs
gs -dNOPAUSE -sDEVICE=jpeg -sOutputFile=image%d.jpg -dJPEGQ=94 -r72x72 -q INPUT_FILE.pdf -c quit

# convert JPGs to PDF
apt-get install imagemagick
convert *.jpg pictures.pdf

# Ubuntu german locale
locale-gen de_DE.UTF-8
echo 'LANG="de_DE"' > /etc/default/locale
cat <<EOF>> ~/.bashrc
export LANG=de_DE.UTF-8
export LC_ALL=de_DE.UTF-8
EOF

# convert charcode
iconv --from-code=UTF-8 --to-code=ISO-8859-1 IN.txt > OUT.txt

# find duplicate files / images
fdupes -r -f -1 PHOTO_DIR > /tmp/duplicates.txt
mkdir duplicates1
cat /tmp/duplicates.txt | xargs  mv -i --target-directory ./duplicates1/

# disable Nvidia logo on Xorg start (/etc/X11/xorg.conf)
Section "Device"
	Option		"NoLogo"	"True"
EndSection

# Reload gnome panels
killall gnome-panel
#? killall gnome-panel nautilus

# SSH X11 forward
ssh -Y YOUR_SERVER -l YOUR_USER xclock

# Mirror a homepage with wget (http://wiki.ubuntuusers.de/wget)
wget  -m http://www.YOUR_DOMAIN.com --reject=pdf,jpg,gif,png,flv,m4v

# Join / combine flv files
mencoder -forceidx -of lavf -oac copy -ovc copy -o Output.flv File_1.flv File_2.flv File_3.flv File_4.flv File_5.flv

# format DVD-RW
dvd+rw-format -force /dev/cdrom

# update kernel partition table
apt-get install -y parted && partprobe

# sync files from webserver
wget -m -np -nH --cut-dirs=1 http://www.YOUR_DOMAIN.com/stsbox/ --reject="index*"#

# view disk UUID
blkid /dev/sda1

# mount ftp
sudo apt-get install -y curlftpfs
sudo curlftpfs USERNAME:PASSWORT@example.com /mnt/

# Extract or convert CUE/BIN files to ISO image
sudo apt-get install bchunk
bchunk FILE_IN.bin FILE_IN.cue FILE_OUT

# Split a file</string>
split -d -b 10M archiv.tar split-archiv.tar.

# Remove files older then 1 day from /tmp
find /tmp/ -mtime +1 -exec rm -r {} \;

# remove apache logs older then 1 year
find /var/log/apache2/ -type f -mtime +365 -exec rm {} \;

# configure limits
/etc/security/limits.conf

# change MAC address
ifconfig eth0 hw ether 00:11:22:33:44:55

# set systemwide default printer
lpadmin -d printer-name

# set user default printer
lpoptions -d printer-name

# Find the speed of your Ethernet card in Linux
ethtool eth0

# Backup package list and install on another system (not tested yet)
dpkg --get-selections | grep -v deinstall > DPKG_LIST.txt
dpkg --clear-selections
dpkg --set-selections < DPKG_LIST.txt
apt-get install

# show file with netcat
while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; cat FILE; } | nc -w 1 -l -p 80; sleep 1; done

# Fix german keyboard
setxkbmap -model pc105 -layout de -variant basic

# fix "Some index files failed to download. They have been ignored, or old ones used instead."
sudo rm -rf /var/lib/apt/lists/*
sudo rm -vf /var/lib/apt/lists/partial/*

# scan and convert to jpg
scanimage --format tiff --mode color -l 0 -t 0 -x 105 -y 74 --resolution 150  | convert - ${FILE}

# Extract strings from a binary
sudo apt-get install -y binutils
strings /usr/bin/passwd

# tar multicore / parallel compression
sudo apt-get install pbzip2
tar -I pbzip2 -cf OUT.tar.bz2 /mnt/

# user specific crontab
# list
crontab -l
# edit
crontab -e
# path
/var/spool/cron/crontabs/<USERNAME>

# Exit code from previous commands
ls /foo | wc; echo ${PIPESTATUS[@]}

# add current directory to libraries path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

# ionice
ionice -c 3 -p 1184	# set priority for process
ionice -p 1170		# view priority of a process

# find file bigger then 50 MB
find /home -type f -size +50M -exec ls -lh {} \;

# view my public ip
curl checkip.dyndns.com

# file write protect
chattr +i /etc/shadow

# find softlinks
find . -type l -exec ls -ld {} \;

# find broken softlinks
find /home/ -type -type l -xtype l

# list deb package dependency
dpkg -I <PACKAGE.deb>

# send POST data from command line
curl --data "user=boo&action=insert" <URL>

# list open ports
netstat -lpnt

# backup crontab
crontab -l > crontab.bkp

# clear crontab
crontab -r

# restore crontab
cat crontab.bkp | crontab -

# backup files only smaller than 10 MB
for DIR in .mozilla .ssh .thunderbird bin foo bar; do
    tar cjf ~/backup/$(date -I).${DIR#.}.tar.bz2 ~/${DIR} --exclude "*~" --exclude-from <(find ~/${DIR} -size +10M)
done

# get file last modification date
stat file

# extract specific file from tar archive
tar -xvf archive.tar <path/to/file>

# get installed package list from remote host
ssh root@REMOTE dpkg -l | grep ii | cut -d " "  -f3 | sort > /tmp/remote.out

# diff installed packages between hosts
diff <(ssh host1.example.com dpkg -l | grep ii | cut -d" " -f3) <(ssh host2.example.com dpkg -l | grep ii | cut -d" " -f3)

# kill all screen processes older then 1 day
killall --older-than 1d screen

# get DNS informations for a domain
dig ANY example.com

# escape string
s="a string escaped by \ from ${USER}"
echo $(printf '%q' "$s")

# show ssh key length
ssh-keygen -l -f ~/.ssh/id_rsa.pub

# download recursively http directory
wget --recursive --no-parent --reject "index.html*" http://www.example.com/dir/

# get CPU / system utilization
cat /proc/loadavg

# backup running system
EXCLUDES="--exclude=dev/* --exclude=proc/* --exclude=sys/* --exclude=tmp/* --exclude=var/log/*"
tar ${EXCLUDES} -cjf /tmp/$(hostname -A).$(date -I).tar.bz2 /

# remove file from tar archive
tar --delete -f archive.tar path/to/file.txt

# restore windows MBR
sudo dd if=/usr/lib/syslinux/mbr.bin of=/dev/sda

# myip
wget -q http://checkip.dyndns.com/ -O-

# convert Dos to Unix line break
tr -d '\r' < INPUT_FILE > OUTPUT_FILE

# configure default user login shell to bash
chsh -s /bin/bash ${USER}

# forward network traffic
iptables -t nat -A POSTROUTING -o <TARGET_NIC> -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward

# list CPU performance by core
mpstat -P ALL

# show how long a process has been running
ps -o etime= -p 123

# suspend from CLI
echo -n mem | sudo tee /sys/power/state
dbus-send --system --print-reply --dest="org.freedesktop.login1" /org/freedesktop/login1 org.freedesktop.login1.Manager.Suspend boolean:true
method return sender=:1.0 -> dest=:1.90 reply_serial=2

# list files / folder by size
du -sh * | sort -h
