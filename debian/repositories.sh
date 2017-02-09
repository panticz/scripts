# Debian Squeeze
cat <<EOF> /etc/apt/sources.list.d/squeeze.list
deb http://archive.debian.org/debian/ squeeze main contrib non-free
deb-src http://archive.debian.org/debian/ squeeze main contrib non-free
EOF

cat <<EOF> /etc/apt/sources.list.d/squeeze-security.list
deb http://security.debian.org/ squeeze/updates main contrib non-free
deb-src http://security.debian.org/ squeeze/updates main contrib non-free
EOF

# Debian Squeeze LTS
cat <<EOF> /etc/apt/sources.list.d/squeeze-lts.list
deb http://archive.debian.org/debian/ squeeze-lts main contrib non-free
deb-src http://archive.debian.org/debian/ squeeze-lts main contrib non-free
EOF
echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/10squeeze-lts-no-check-valid-until

# Debian Squeeze backports
cat <<EOF> /etc/apt/sources.list.d/squeeze-backports.list
deb http://ftp.de.debian.org/debian-backports squeeze-backports main
deb-src http://ftp.de.debian.org/debian-backports squeeze-backports main
EOF

# Debian Wheezy
cat <<EOF> /etc/apt/sources.list.d/wheezy.list
deb http://http.debian.net/debian/ wheezy main contrib non-free
deb-src http://http.debian.net/debian/ wheezy main contrib non-free
EOF

cat <<EOF> /etc/apt/sources.list.d/wheezy-security.list
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free
EOF

cat <<EOF> /etc/apt/sources.list.d/wheezy-updates.list
deb http://ftp.de.debian.org/debian/ wheezy-updates main contrib non-free
deb-src http://ftp.de.debian.org/debian/ wheezy-updates main contrib non-free
EOF

# Debian Wheezy backports
cat <<EOF> /etc/apt/sources.list.d/wheezy-backports.list
deb http://ftp.de.debian.org/debian wheezy-backports main
deb-src http://ftp.de.debian.org/debian wheezy-backports main
EOF

# Debian Jessie
cat <<EOF> /etc/apt/sources.list.d/jessie.list
deb http://http.debian.net/debian/ jessie main contrib non-free
deb-src http://http.debian.net/debian/ jessie main contrib non-free
EOF

# Debian Jessie backports
cat <<EOF> /etc/apt/sources.list.d/jessie-backports.list
deb ftp://ftp.de.debian.org/debian/ jessie-backports main contrib non-free
deb-src ftp://ftp.de.debian.org/debian/ jessie-backports main contrib non-free
EOF
