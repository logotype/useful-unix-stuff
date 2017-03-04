Create IPSec VPN server (Ubuntu 15.04 Vivid Vervet)
----------------------

_Replace **`<SERVER-IP>`** with your servers external, public IP._

Install dependencies:

```bash
$ sudo apt-get install libnss3-dev libnspr4-dev pkg-config libpam-dev libcap-ng-dev libcap-ng-utils libselinux-dev libcurl4-nss-dev libgmp3-dev flex bison gcc make libunbound-dev libnss3-tools libevent-dev xmlto
```

Download Libreswan, unpack and compile:

```bash
$ wget https://github.com/libreswan/libreswan/archive/v3.15.tar.gz
$ tar -xvzf v3.15.tar.gz
$ cd libreswan-3.15/
$ make programs
$ sudo make install
$ systemctl enable ipsec.service
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

# Enable IPV4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t nat -A POSTROUTING -j SNAT --to-source <SERVER-IP> -o eth0
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
