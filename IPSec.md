Create IPSec VPN server (Ubuntu Server 16.04 LTS)
----------------------

_Replace **`<SERVER-IP>`** with your servers external, public IP._

Install dependencies:

```bash
$ export USE_FIPSCHECK=false
$ sudo apt-get install libnss3-dev libnspr4-dev pkg-config libpam-dev libcap-ng-dev libcap-ng-utils libselinux-dev libcurl3-nss-dev flex bison gcc make libunbound-dev libnss3-tools libevent-dev xmlto libsystemd-dev
```

Download Libreswan, unpack and compile:

```bash
$ wget https://github.com/libreswan/libreswan/archive/v3.20.tar.gz
$ tar -xvzf v3.20.tar.gz
$ cd libreswan-3.20/
$ make programs
$ sudo make install
$ sudo systemctl enable ipsec.service
```

Enable kernel IP packet forwarding and disable ICMP redirects by adding the below.

Edit `/etc/rc.local` and `sudo chmod +x /etc/rc.local` to run the following at boot:

```bash
# Disable send redirects
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/lo/send_redirects

# Disable accept redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/lo/accept_redirects

# Disable rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/eth0/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/ip_vti0/rp_filter

# Enable IPV4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

sudo iptables -t nat -A POSTROUTING -j SNAT --to-source <SERVER-IP> -o eth0
```

Edit `/etc/ipsec.conf`:

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
	left=<SERVER-IP>
	leftsourceip=<SERVER-IP>
	leftsubnet=0.0.0.0/0
	right=%any
	rightsubnet=10.0.1.0/24
	dpddelay=10
	dpdtimeout=600
	dpdaction=clear
	forceencaps=yes
```

Edit `/etc/ipsec.secrets` to add the shared secret:

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
