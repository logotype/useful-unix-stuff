Create PPTP VPN server
----------------------
First of all, you need to install pptpd, with the following commands:

```bash
$ wget http://poptop.sourceforge.net/yum/stable/rhel6/x86_64/pptpd-1.4.0-1.el6.x86_64.rpm
$ yum localinstall pptpd-1.4.0-1.el6.x86_64.rpm
```

And update pptpd configurations in file /etc/pptpd.conf, by adding the following lines:

```bash
localip     192.168.9.1
remoteip    192.168.9.11-30
```
The localip field determines the IP address of your EC2 instance on the VPN, while remoteip field determines the IP address of connected clients. Because there may be potentially many clients connecting to this VPN, the remoteip is a range of 20 IP addresses.

Optionally, you might want need to tell your clients to use some specific DNS server. This could be done by editing /etc/ppp/options.pptpd, and add the following lines:

```bash
ms-dns    8.8.8.8
ms-dns    8.8.4.4
We are using Google’s public DNS servers here.
```

Now you want to setup VPN username and password in `/etc/ppp/chap-secrets`. Each line in the file has the format:

```bash
<username> pptpd <passwd> *
```
Next step is to enable IP forwarding. Edit `/etc/sysctl.conf`, use the following config:

```bash
net.ipv4.ip_forward = 1
```

You need to reload the configuration by `/sbin/sysctl -p`.

And we also need to enable iptables NAT configuration:

```bash
$ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

To ensure the NAT configuration be loaded when the machine boots, it might be a good idea to add in your `/etc/rc.local` the command `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`.

OK, it’s nearly finished! You need to start the pptpd service, and set it to automatically start when the machine boots:

```bash
$ /sbin/service pptpd start
$ chkconfig pptpd on
```

ONE FINAL THING: be sure to enable TCP port 1723 of your EC2 instance, otherwise the firewall will prevent your VPN from working!

If the VPN server is not working correctly, check `/var/log/messages` for error messages.
