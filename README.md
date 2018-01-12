useful-unix-stuff
=================

a collection of useful unix commands/scripts/etc

```bash
# No password for sudo
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Run the last command as root
sudo !!

# Just because it's funny
alias please='sudo'

# ext2/ext3/ext4 file system resizer (e.g. resize EC2 root volume to actual disk size)
sudo resize2fs /dev/xvda1

# Mount options for /etc/fstab
UUID=<UUID> /home/ec2-user/<some mount path> ext4 defaults,nofail 0 2

# List drives
lsblk

# List drives by UUID
ls -l /dev/disk/by-uuid

# Start HTTPD at boot (CentOS)
sudo chkconfig --levels 345 httpd on

# Mirror site with wget
wget -p -r -l4 -E -k -nH <url>

# Download all files listed in urls.txt
xargs -n 1 curl -O < urls.txt

# Move many files (millions of files..)
echo *.ext | xargs mv -t <path>

# Read large file quickly (faster than "more");
less <file>

# View last 100 lines of file
tail -100 <file>

# Clear contents of file
truncate -s 0 <file>

# Run programs and summarize system resource usage
time nslookup <domain> 8.8.8.8

# Redirect stdout and stderr to log file with timestamps
./some_script.sh 2>&1 | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> some_script.log

# Get User-Agents from nginx logfile
cat <file> | grep "GET" | awk -F'"' '{print $6}' | cut -d' ' -f1 | grep -E '^[[:alnum:]]' | sort | uniq -c | sort -rn

# Merge multiple files, recursively
find . -name "<file>.<ext>" -o -name "<file>*.<ext>" | xargs cat > ./<outputfile>

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

# SHA 512 sum of file (macOS)
openssl dgst -sha512 <file>

# MD5 sum of file
md5 <file>

# ~/.ssh/config example (easily SSH to host with "ssh example")
# Host example
# Hostname 111.222.333.444
# User ec2-user
# IdentityFile ~/.ssh/example.pem

# SSH copy from remote host to local (<example> is the Host in ~/.ssh/config)
scp example:/some/path/on/remove/server/file.ext localfile.ext

# rsync from local to remote host, excluding mac files (<example> is the Host in ~/.ssh/config)
rsync -rave "ssh -i /Users/$USER/.ssh/example.pem" --exclude ".DS_Store" -r . example:~/some-directory-here

# Last 100 most used commands
history | sed "s/^[0-9 ]*//" | sed "s/ *| */\n/g" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 100

# Determine directory where this script is running from (1)
cd ${0%/*}

# Determine directory where this script is running from (2)
script_dir=$(dirname $(echo $0 | sed -e "s,^\([^/]\),$(pwd)/\1,"))

# Clear console in Node.js (*nix)
console.log('\033[2J');

# Connect to Cisco ASA devices via USB console cable
screen /dev/tty.usbserial-a103xxxxx

# List files displaying permissions in octal values (755 drwxr-xr-x, 644 -rw-r--r--)
alias lso="ls -alG | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"

# Sum all numbers in a file using awk
awk '{ sum += $1 } END { print sum }' <file>

# List all files installed by package (CentOS)
rpm -ql <package>

# Search for filename containing "options" installed by package "pptpd" (CentOS)
rpm -ql pptpd | grep options

# Get IP address (Ethernet 0):
/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

# Get IP address (All interfaces):
/sbin/ifconfig | grep -B1 "inet addr" | awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' | awk -F: '{ print $1 ": " $3 }'

# Send UDP message to a specific host and port using NetCat
nc -u <ip> <port> <<< '<message>'

# Check if TCP or UDP port is open (/dev/tcp/host/port or /dev/udp/host/port)
cat < /dev/tcp/127.0.0.1/22

# Scan for RDP (10.0.1.0 - 10.0.1.255)
nmap -p3389 -P0 -sS 10.0.1.0/24 | grep "scan" | cut -d "(" -f2 | cut -d ")" -f1

# ipsec newhostkey hangs: ipsec newhostkey --configdir /etc/ipsec.d --output ~/ipsec.secrets --bits 4096
mv /dev/random /dev/chaos
ln -s /dev/urandom /dev/random

# Connect to VPN service (macOS) ref: http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx
scutil --nc start <name_of_service> --user <vpn_username> --password <vpn_password>

# Monitor pppd log
tail -f /var/log/syslog | grep pppd

# Bandwidth trottling, enabling 150kB/s on port 80 (removed from recent versions of macOS)
sudo ipfw pipe 1 config bw 150KByte/s
sudo ipfw add 1 pipe 1 src-port 80

# Bandwidth trottling, disable
sudo ipfw delete 1

# Check if MTU size is wrong (fragmented packets)
tcpdump -i eth0 -s 1500 port not 22 | strings | grep "frag"

# Check current DNS servers used
cat /etc/resolv.conf

# Google public recursive DNS
8.8.8.8
8.8.4.4

# Quad9 public recursive DNS
9.9.9.9

# Level3 public recursive DNS
4.2.2.1
4.2.2.2
4.2.2.3
4.2.2.4
4.2.2.5
4.2.2.6

# Like top, but for networking (built in macOS)
nettop

# Like top, but for disk I/O
iotop

# Like top
htop

# Disable ecAssessment system policy security (allow unidentified app to be started)
sudo spctl --master-disable

# Convert PNG image sequence (image-000.png) to H.264 using ffmpeg
ffmpeg -i ./image-%03d.png -f mp4 -vcodec libx264 -pix_fmt yuv420p <filename>.mp4

# AWS S3: Get total size and number of files of bucket
aws s3api list-objects --bucket <bucket_name> --output json --query "[sum(Contents[].Size), length(Contents[])]"

# SSH login without password
ssh-keygen -t rsa -b 2048 -v
ssh-copy-id -i ~/.ssh/<cert>.pub <user>@<server-ip>

# xenserver start all hosts
xe vm-start --multiple

```

--------------------------
Built with IntelliJ IDEA Open Source License

<a href="https://www.jetbrains.com/buy/opensource/"><img src="https://s3-ap-southeast-1.amazonaws.com/www.logotype.se/assets/logo-text.svg" width="200"></a>

The people at JetBrains supports the Open Source community by offering free licenses. Check out <a href="https://www.jetbrains.com/buy/opensource/">JetBrains Open Source</a> to apply for your project. Thank you!
