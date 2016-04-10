#!/usr/bin/env sh

# Find "CNNIC ROOT" SHA1 (CA root certificate on OSX)
sudo security find-certificate -a -Z -c "CNNIC ROOT" /System/Library/Keychains/SystemRootCertificates.keychain | grep SHA-1

# Delete "CNNIC ROOT" CA root certificate (find the hash using the above command)
sudo security delete-certificate -t -Z 8BAF4C9B1DF02A92F7DA128EB91BACF498604B6F /System/Library/Keychains/SystemRootCertificates.keychain

# Get IP address (Ethernet 0):
/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

# Get IP address (All interfaces):
/sbin/ifconfig | grep -B1 "inet addr" | awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' | awk -F: '{ print $1 ": " $3 }'

# Run the last command as root
sudo !!

# Resize EC2 root volume to actual disk size
sudo resize2fs /dev/xvda1

# Start HTTPD at boot (CentOS)
sudo chkconfig --levels 345 httpd on

# Dump database to remote server using pipe (MySQL)
mysqldump -u <user> -p<password> <database> | mysql --host=<server> --user=<user> --password=<password> <database>

# If mysqld can't start ("MySQL Daemon Failed to Start"), on CentOS 6.x with <= 512MB RAM, edit /etc/my.cnf under [mysqld]
performance_schema=off

# Mirror site with wget
wget -p -r -l4 -E -k -nH <url>

# Read textfile backwards, opposite of "more"
less <file>

# Get User-Agents from nginx logfile
cat <file> | grep "GET" | awk -F'"' '{print $6}' | cut -d' ' -f1 | grep -E '^[[:alnum:]]' | sort | uniq -c | sort -rn

# Get CPU info
grep "model name" /proc/cpuinfo

# Get number of CPUs
grep processor /proc/cpuinfo | wc -l

# Get total memory (in MB)
awk '/MemTotal/ {printf( "%.2fMB\n", $2 / 1024 )}' /proc/meminfo

# Get files over 50MB
find <path> -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

# Find file by name and ignore errors
find / -name "<name>" 2> /dev/null

# Find files containing string
grep -Ril "<string>" ./

# Download all files listed in urls.txt
xargs -n 1 curl -O < urls.txt

# Bandwidth trottling, enabling 150kB/s on port 80
sudo ipfw pipe 1 config bw 15KByte/s
sudo ipfw add 1 pipe 1 src-port 80

# Monitor pppd log
tail -f /var/log/syslog | grep pppd

# Bandwidth trottling, enabling
sudo ipfw delete 1

# When "sudo npm" fails on CentOS EC2
sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

# ~/.ssh/config example (easily SSH to host with "ssh example")
# Host example
# Hostname 111.222.333.444
# User ec2-user
# IdentityFile ~/.ssh/example.pem

# SSH copy from remote host to local (<example> is the Host in ~/.ssh/config)
scp example:/some/path/on/remove/server/file.ext localfile.ext

# Last 100 most used commands
history | sed "s/^[0-9 ]*//" | sed "s/ *| */\n/g" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 100

# Determine directory where this script is running from (1)
cd ${0%/*}

# Determine directory where this script is running from (2)
script_dir=$(dirname $(echo $0 | sed -e "s,^\([^/]\),$(pwd)/\1,"))

# Clear console in Node.js (*nix)
console.log('\033[2J');

# Send UDP message to a specific host and port using NetCat
nc -u <ip> <port> <<< '<message>'

# 1. OpenCV: Compile with C++11
# 2. OpenCV: Build
CC=clang CXX=clang++ CFLAGS='-m64' CXXFLAGS='-std=c++0x -stdlib=libc++ -m64 -Wno-c++11-narrowing' cmake -G "Unix Makefiles" -D CMAKE_INSTALL_PREFIX=/Users/<username>/Library/Developer/opencv/ -D WITH_QUICKTIME=OFF -D BUILD_EXAMPLES=OFF -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_CARBON=OFF -D CMAKE_OSX_ARCHITECTURES=x86_64 -D BUILD_PERF_TESTS=OFF -D BUILD_SHARED_LIBS=OFF -D BUILD_opencv_legacy=NO ..
make -j8

# 1. Compile Boost C++ library with C++11 (as static)
# 2. Compile Boost C++ library with C++11 (as static)
./bootstrap.sh --with-toolset=clang
./b2 toolset=clang cxxflags="-std=c++11 -stdlib=libc++" linkflags="-stdlib=libc++" link=static

# Just because it's funny
alias please='sudo'

# List files displaying permissions in octal values
alias lso="ls -alG | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"

# Sum all numbers in a file using awk
awk '{ sum += $1 } END { print sum }' <file>

# List all files installed by package (CentOS)
rpm -ql <package>

# Search for filename containing "options" installed by package "pptpd" (CentOS)
rpm -ql pptpd | grep options

# ipsec newhostkey hangs: ipsec newhostkey --configdir /etc/ipsec.d --output ~/ipsec.secrets --bits 4096
mv /dev/random /dev/chaos
ln -s /dev/urandom /dev/random

# Connect to VPN service (OSX) ref: http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx
scutil --nc start <name_of_service> --user <vpn_username> --password <vpn_password>

# Check if MTU size is wrong (fragmented packets)
tcpdump -i eth0 -s 1500 port not 22 | strings | grep "frag"

# Check if TCP or UDP port is open (/dev/tcp/host/port or /dev/udp/host/port)
cat < /dev/tcp/127.0.0.1/22

# Check current DNS servers used
cat /etc/resolv.conf

# Level3 public recursive DNS
4.2.2.1
4.2.2.2
4.2.2.3
4.2.2.4
4.2.2.5
4.2.2.6

# Google public recursive DNS
8.8.8.8
8.8.4.4

# PHP-FPM session (/etc/php-fpm.d/www.conf)
php_value[session.save_handler] = files
php_value[session.save_path] = /var/lib/php/session

# Convert PNG image sequence (image-000.png) to H.264 using ffmpeg
ffmpeg -i ./image-%03d.png -f mp4 -vcodec libx264 -pix_fmt yuv420p output.mp4
