Create PPTP VPN server
----------------------

__Enable TCP port 1723 of the EC2 instance’s Security Group__

Install pptpd:

```bash
$ wget http://poptop.sourceforge.net/yum/stable/rhel6/x86_64/pptpd-1.4.0-1.el6.x86_64.rpm
$ yum localinstall pptpd-1.4.0-1.el6.x86_64.rpm
```

Edit `/etc/pptpd.conf`:

```bash
localip     192.168.9.1
remoteip    192.168.9.11-30
```
The `localip` field determines the IP address of your EC2 instance on the VPN, while `remoteip` field determines the IP address of connected clients. The `remoteip` is a range of 20 IP addresses.

Edit `/etc/ppp/options.pptpd` and add a DNS provider, Google in this case:

```bash
ms-dns    8.8.8.8
ms-dns    8.8.4.4
```

Add VPN users by editing `/etc/ppp/chap-secrets`. Each line in the file has the format:

```bash
<username> pptpd <passwd> *
```
Enable IP forwarding by editing `/etc/sysctl.conf`:

```bash
net.ipv4.ip_forward = 1
```

Reload the configuration by `/sbin/sysctl -p`.

Enable iptables NAT configuration:

```bash
$ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

On Rackspace, enable incoming connections on TCP 1723:
```bash
$ sudo /sbin/iptables -I INPUT 1 -p tcp --dport 1723 -j ACCEPT
```

To ensure the NAT configuration be loaded when the instance starts, add in your `/etc/rc.local` the command `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`.

Start the pptpd service, and set it to automatically start when the instance starts:

```bash
$ /sbin/service pptpd start
$ chkconfig pptpd on
```

Check `/var/log/messages` for error messages.
