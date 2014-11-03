# Debian Squeeze
cat <<EOF> /etc/apt/sources.list.d/squeeze.list
deb http://cdn.debian.net/debian squeeze main
deb-src http://cdn.debian.net/debian squeeze main
EOF

# Debian Squeeze LTS
cat <<EOF> /etc/apt/sources.list.d/squeeze-lts.list
deb http://http.debian.net/debian/ squeeze-lts main contrib non-free
deb-src http://http.debian.net/debian/ squeeze-lts main contrib non-free
EOF

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
cat <<EOF> /etc/apt/sources.list.d/jessie.list
deb ftp://ftp.de.debian.org/debian/ jessie-backports main contrib non-free
deb-src ftp://ftp.de.debian.org/debian/ jessie-backports main contrib non-free
EOF
