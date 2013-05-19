# Get IP address (Ethernet 0):
/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

# Get IP address (All interfaces):
/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }'

# Find file by name and ignore errors
find / -name "<name>" 2> /dev/null

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

# When "sudo npm" fails on CentOS EC2
sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf
