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

# Use directory location of bash script if running from elsewhere
cd ${0%/*}

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