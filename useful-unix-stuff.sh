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