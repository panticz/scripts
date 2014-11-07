<strong>String replace with sed</strong>
<code>sed -i 's|STRING_FROM|STRING_TO|g' FILE
sed  -i 's|[#]*param=[yes|no]*|param=yes|g' FILE
</code>

<strong>add line to a file</strong>
sed -i '13i\YOUR_TEXT' FILE

<strong>remove multiple blanks</strong>
cat in.txt | sed "s/[ ][ ]*/ /g" > out.txt

<strong>String regexp</strong>
if [[ "${MOTHERBOARD}" =~ H8DM(8|E)-2 ]] &&  [[ "${RAID}" =~ 9650SE-(4|8)LPML ]]; then
   echo "found"
fi

<strong>Comparing content of two files</strong>
comm -12 <(sort FILE1.txt) <(sort FILE2.txt)

<strong>Split file to DVD-R size</strong>
split -b 4400m -d file.dd.bz2 file.dd.bz2.

<strong>Fix file permissions</strong>
find /media/images/ -type f -exec chmod 666 {} \;

<strong>Extract RPM archiv</strong>
<code>rpm2cpio FILENAME | cpio -i --make-directories</code>

<strong>Extract cue / bin image</strong>
sudo apt-get install -y bchunk
bchunk file_name.bin file_name.cue file_name.iso

<strong>Get file atime, mtime, ctime</strong>
<code>stat FILE</code>

<strong>Change mtime from a file</strong>
<code>touch -d "2005-05-05 15:55:55" FILE</code>

<strong>Create selfextract archive under Linux</strong>
<code>makeself.sh [-bzip2] DIR archiv.run "DESCRIPTION" COMMAND</code>

<strong>Create Linux software RAID</strong>
<code>mdadm --create /dev/md2 --level=raid5 --raid-devices=4 --spare-devices=0 /dev/sdb4
/dev/sdc4 /dev/sdd4</code>

<strong>Wake On Lan (WOL)</strong>
<code>wakeonlan 00:11:22:33:44:55</code>

<strong>Change root and start bash</strong>
<code>chroot /mnt /bin/bash</code>

<strong>Enable / Disable swap</strong>
<code>swapoff -a
swapon -a</code>

<strong>extract initrd.gz</strong>
gunzip < initrd.gz | cpio -i --make-directories

<strong>extract initrd.lz</strong>
unlzma -c -S .lz ../initrd.lz | cpio -id

<strong>compress initrd</strong>
find ./ | cpio -H newc -o > ../initrd
gzip ../initrd

<strong>Extract *.deb</strong>
dpkg-deb -x file.deb /tmp

<strong>Find package for a file</strong>
dpkg-query -S FILE_NAME

<strong>Add script to a runlevel</strong>
sudo update-rc.d providername start 90 2 3 5 . stop 10 0 1 4 6 .

<strong>Most used commands</strong>
history | awk '{print $2}' | sort | uniq -c | sort -rn | head

<strong>VNC on slow connection</strong>
xtightvncviewer -compresslevel 9 -quality 0 192.168.0.100
xvnc4viewer -ZlibLevel 9 -LowColourLevel 0 192.168.0.110

<strong>Format partition as FAT16</strong>
mkdosfs -F 16 -n SDCARD /dev/sdd1

<strong>Forcing kernel to use new partition table after fdisk</strong>
partprobe

<strong>list blocking prozesses</strong>
lsof /mnt

<strong>Add a existing user to existing group</strong>
usermod -a -G GROUPNAME USERNAME

<strong>Delete user from group</strong>
edit /etc/group and remove user name
or
id -nG USERNAME
usermod -G group1, group2, group3,... USERNAME
# test gpasswd

<strong>Mount SSH</strong>
sshfs user@192.168.1.2:/media/images /mnt

<strong>unmask</strong>
global: /etc/profile
echo "umask 0000" >> ~/.profile

<strong>check for listening ports</strong>
netstat -anp | grep 1234
lsof -i | grep 1234

<strong>dpkg install force-architecture</strong>
dpkg  --force-architecture -i *.deb

<strong>display bandwidth usage</strong>
iftop

<strong>log loadavg</strong>
echo "$(date) $(cat /proc/loadavg)" >> loadavg.log

<strong>convert qcow2 to raw image</strong>
qemu-img convert -f qcow2 root.qcow2 -O raw root.raw

<strong>losetup</strong>
losetup -a - list all used devices
losetup -d loop_device - delete loop
losetup -f -  print name of first unused loop device

<strong>reconfigure keyboard / console</strong>
dpkg-reconfigure console-setup

<strong>kill all prozess from a user</strong>
ps -u USERNAME |  awk '{print $1}' | xargs kill -9

<strong>view nfs shares</strong>
showmount --exports 192.168.0.1

<strong>connect with gnome nautilus to ssh</strong>
sftp://root@SERVER/SHARE

<strong>disable monitor power save (disable DPMS)</strong>
xset -dpms

<strong>disable console, x11 screensaver</strong>
xset s 0 0
xset s noblank
xset s off
xset -dpms
setterm -blank 0
setterm -powersave off
setterm -powerdown 0

<strong>force umount</strong>
sudo umount -l -f /mnt/mountpoint

<strong>convert nero cd image to iso</strong>
nrg2iso infile.nrg outfile.iso

<strong>enable harddisk udma mode</strong>
hdparm -d1 /dev/hda

<strong>remove multiple spaces from a string</strong>
cat x.txt | tr -s " "

<strong>create uniqe file from two files</strong>
dos2unix adr_*.txt;  cat adr_hp.txt adr_sel.txt | sort | uniq > adr_uniq.txt

<strong>copy files between hosts with SSH and tar</strong>
tar -cf - /some/file | ssh host.name tar -xf - -C /destination

<strong>read cd volume label</strong>
dd if=/dev/hdd bs=1 skip=32808 count=32 2> /dev/null | tr -d " "

<strong>rebuild initrd</strong>
gzip -d miniroot.gz; mount miniroot /mnt/ -o loop; vi /mnt/linuxrc; gzip --best miniroot

<strong>Fix slow SSH login</strong>
echo "UseDNS no" >>  /etc/ssh/sshd_config

<strong>set hostname</strong>
echo myhost.local > /etc/hostname; /etc/init.d/hostname.sh start

<strong>start xterm in Xorg session</strong>
cat <<EOF> $HOME/.xsession
xterm
EOF

<strong>change language temporary on command line</strong>
export LANG="en_US.UTF-8"

<strong>fix broken package with apt-get (dpkg)</strong>
rm /var/lib/dpkg/info/PACKAGE_NAME*
dpkg –remove –force-depends –force-remove-reinstreq PACKAGE_NAME

<strong>configure timezone</strong>
dpkg-reconfigure tzdata

<strong>allow user to administrate system (add to adm group)</strong>
usermod -a -G adm $USER

<strong>change password non interactive</strong>
echo "root:terceS" | chpasswd

<strong>clean mbr</strong>
dd if=/dev/zero of=/dev/sdb bs=446 count=1

<strong>create checksum</strong>
echo "foo" | md5sum

<strong>MD5-Hash password</strong>
echo terceS | mkpasswd -s -H MD5

<strong>create tmpfs</strong>
cat <<EOF>> $TARGET/etc/fstab
tmpfs   /tmp   tmpfs   defaults   0   0
EOF

<strong>set / change volume label</strong>
e2label /dev/sda1 newlabel
tune2fs -L newlabel /dev/sda1

<strong>clean ubuntu trash</strong>
sudo rm -rf ~/.local/share/Trash/files/*

<strong>convert ISO-8859-1 to UTF-8</strong>
iconv --from-code=ISO-8859-1 --to-code=UTF-8 file.in > file.out file.in > file.out

<strong>Extract Windows cab file</strong>
cabextract CAB_FILE_NAME.exe

<strong>set recursive directory rights</strong>
find . -type f -exec chmod 644 {} \;

<strong>extract pages from PDF file</strong>
pdftk IN.pdf cat 1-5 output OUT.pdf
pdftk IN1.pdf IN2.pdf output OUT.pdf

<strong>merge pdf sites to a single dokument</strong>
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile=out.pdf *.pdf
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dPDFSETTINGS=/ebook -dPDFFitPage -sOutputFile=OUT.pdf IN.pdf

<strong>Convert PDF to JPGs</strong>
gs -dNOPAUSE -sDEVICE=jpeg -sOutputFile=image%d.jpg -dJPEGQ=94 -r72x72 -q INPUT_FILE.pdf -c quit

<strong>convert JPGs to PDF</strong>
apt-get install imagemagick
convert *.jpg pictures.pdf

<strong>Ubuntu german locale</strong>
locale-gen de_DE.UTF-8
echo 'LANG="de_DE"' > /etc/default/locale
cat <<EOF>> ~/.bashrc
export LANG=de_DE.UTF-8
export LC_ALL=de_DE.UTF-8
EOF

<strong>convert charcode</strong>
iconv --from-code=UTF-8 --to-code=ISO-8859-1 IN.txt > OUT.txt

<strong>find duplicate files / images</strong>
fdupes -r -f -1 PHOTO_DIR > /tmp/duplicates.txt
mkdir duplicates1
cat /tmp/duplicates.txt | xargs  mv -i --target-directory ./duplicates1/

<strong>disable Nvidia logo on Xorg start (/etc/X11/xorg.conf)</strong>
Section "Device"
	Option		"NoLogo"	"True"
EndSection

<strong>Reload gnome panels</strong>
killall gnome-panel
#? killall gnome-panel nautilus

<strong>SSH X11 forward</strong>
ssh -Y YOUR_SERVER -l YOUR_USER xclock

<strong>Mirror a homepage with wget (http://wiki.ubuntuusers.de/wget)</strong>
wget  -m http://www.YOUR_DOMAIN.com --reject=pdf,jpg,gif,png,flv,m4v

<strong>Join / combine flv files</strong>
mencoder -forceidx -of lavf -oac copy -ovc copy -o Output.flv File_1.flv File_2.flv File_3.flv File_4.flv File_5.flv

<strong>format DVD-RW</strong>
dvd+rw-format -force /dev/cdrom

<strong>update kernel partition table</strong>
apt-get install -y parted && partprobe

<strong>sync files from webserver</strong>
wget -m -np -nH --cut-dirs=1 http://www.YOUR_DOMAIN.com/stsbox/ --reject="index*"#

<strong>grep list only the file name</strong>
grep  PATTERN -o *

<strong>view disk UUID and label</strong>
blkid /dev/sda1

<strong>mount ftp</strong>
sudo apt-get install -y curlftpfs
sudo curlftpfs USERNAME:PASSWORT@example.com /mnt/

<strong>Extract or convert CUE/BIN files to ISO image</strong>
sudo apt-get install bchunk
bchunk FILE_IN.bin FILE_IN.cue FILE_OUT

<strong>Split a file</string>
split -d -b 10M archiv.tar split-archiv.tar.

<strong>Remove files older then 1 day from /tmp</strong>
find /tmp/ -mtime +1 -exec rm -r {} \;

<strong>configure limits</strong>
/etc/security/limits.conf

<strong>change MAC address</strong>
ifconfig eth0 hw ether 00:11:22:33:44:55

<strong>generate password</strong>
tr -dc "[:alnum:][:punct:]" < /dev/urandom | head -c 12; echo \n

<strong>set systemwide default printer</strong>
lpadmin -d printer-name

<strong>set user default printer</strong>
lpoptions -d printer-name

<strong>Find the speed of your Ethernet card in Linux</strong>
ethtool eth0

<strong>Backup package list and install on another system (not tested yet)</strong>
dpkg --get-selections | grep -v deinstall > DPKG_LIST.txt
dpkg --clear-selections
dpkg --set-selections < DPKG_LIST.txt
apt-get install

<strong>show file with netcat</strong>
while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; cat FILE; } | nc -w 1 -l -p 80; sleep 1; done

<strong>Fix german keyboard</strong>
setxkbmap -model pc105 -layout de -variant basic

<strong>displaying file without commentary and empty lines</strong>
egrep -v '^(#|$)' FILE_NAME

<strong>fix "Some index files failed to download. They have been ignored, or old ones used instead."</strong>
sudo rm -rf /var/lib/apt/lists/*
sudo rm -vf /var/lib/apt/lists/partial/*

<strong>scan and convert to jpg</strong>
scanimage --format tiff --mode color -l 0 -t 0 -x 105 -y 74 --resolution 150  | convert - ${FILE}

<strong>Extract strings from a binary</strong>
sudo apt-get install -y binutils
strings /usr/bin/passwd

<strong>tar multicore / parallel compression</strong>
sudo apt-get install pbzip2
tar -I pbzip2 -cf OUT.tar.bz2 /mnt/

<strong>user specific crontab</strong>
# list
crontab -l
# edit
crontab -e
# path
/var/spool/cron/crontabs/<USERNAME>

<strong>Exit code from previous commands</strong>
ls /foo | wc; echo ${PIPESTATUS[@]}

# add current directory to libraries path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
