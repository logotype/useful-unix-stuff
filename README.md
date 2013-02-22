useful-unix-stuff
=================

a collection of useful unix commands/scripts/etc

Get IP address on command line:
/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
