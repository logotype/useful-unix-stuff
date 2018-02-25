Create IPSec VPN server (Ubuntu Server 16.04 LTS)
----------------------

_Replace **`<SERVER-IP>`** with your servers external, public IP._

Install dependencies:

```bash
$ export USE_FIPSCHECK=false
$ sudo apt update
$ sudo apt upgrade
$ sudo apt-get install libnss3-dev libnspr4-dev pkg-config libpam-dev libcap-ng-dev libcap-ng-utils libselinux-dev libcurl3-nss-dev flex bison gcc make libldns-dev libunbound-dev libnss3-tools libevent-dev xmlto libsystemd-dev
```

Download Libreswan, unpack and compile:

```bash
$ wget https://github.com/libreswan/libreswan/archive/v3.23.tar.gz
$ tar -xvzf v3.23.tar.gz
$ cd libreswan-3.20/
$ sudo make programs
$ sudo make install
$ sudo systemctl enable ipsec.service
```

Enable kernel IP packet forwarding and disable ICMP redirects by adding the below.

Edit `/etc/sysctl.conf` and `sudo sysctl -p` to reload config:

```bash
# Enable IPV4 forwarding
net.ipv4.ip_forward=1

# Disable accept redirects
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0

# Disable send redirects
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0

# Disable rp_filter
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.eth0.rp_filter=0
net.ipv4.conf.lo.rp_filter=0
net.ipv4.conf.ip_vti0.rp_filter=0
```

iptables config (depending on environment). Update in `/etc/rc.local` (chmod 755 and +x the file)

Tested in AWS (slightly slower than SNAT):
```bash
sudo iptables --table nat --append POSTROUTING --jump MASQUERADE
```

Tested in Rackspace:
```bash
sudo iptables -t nat -A POSTROUTING -j SNAT --to-source <SERVER-IP> -o eth0
```

Edit `/etc/ipsec.d/<CONNECTION-NAME>.conf`:

```bash
conn <CONNECTION-NAME>
	authby=secret
	pfs=no
	type=tunnel
	keylife=10h
	keyingtries=150
	ikelifetime=10h
	auto=add
	ike=aes256-sha1-modp1024
	phase2alg=aes256-sha1
	aggrmode=no
	left=<SERVER-PRIVATE-IP>
	leftsourceip=<SERVER-IP>
	leftsubnet=0.0.0.0/0
	right=%any
	rightsubnet=10.0.0.0/8
	dpddelay=10
	dpdtimeout=600
	dpdaction=clear
```

Edit `/etc/ipsec.d/<CONNECTION-NAME>.secrets` to add the shared secret:

```bash
<SERVER-IP>  %any:   PSK "**some-secret-string-here**"
```

Verify everything is okay:

```bash
$ sudo ipsec verify
```

Notes for AWS/EC2
-----------------
The Pluto service is listening for IKE and IKE/NAT-T on specific ports. In your Security Group, add a Custom UDP Rule for port 500 and 4500 with source 0.0.0.0/0.
For communication between EC2 hosts, make sure that hosts are either in same Security Group, or add rule to allow inbound traffic from the same subnet. 
