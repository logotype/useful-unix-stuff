Create L2TP/IPSec VPN server (Ubuntu 14.04 LTS)
----------------------

_Replace **`<SERVER-IP>`** with your servers external, public IP._

Install services:

```bash
$ apt-get install openswan xl2tpd ppp lsof
```

Firewall and sysctl:

```bash
$ iptables -I INPUT 1 -p tcp --dport 1701 -j ACCEPT
$ iptables -t nat -A POSTROUTING -j SNAT --to-source <SERVER-IP> -o eth+
$ sysctl -p
```

Enable kernel IP packet forwarding and disable ICP redirects:

```bash
echo "net.ipv4.ip_forward = 1" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" |  tee -a /etc/sysctl.conf
```

```bash
$ for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done
$ sysctl -p
```

Edit `/etc/rc.local` to run the following at boot:

```bash
for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done
iptables -t nat -A POSTROUTING -j SNAT --to-source <SERVER-IP> -o eth+
```

Edit `/etc/ipsec.conf`:

```bash
version 2

config setup
    dumpdir=/var/run/pluto/
    # Pluto daemon runs here

    nat_traversal=yes
    # Whether to accept/offer to support NAT (NAPT, also known as "IP Masqurade") workaround for IPsec

    virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v6:fd00::/8,%v6:fe80::/10
    # Contains the networks that are allowed as subnet for the remote client (the address ranges that may live behind a NAT router through which a client) connects.

    protostack=netkey
    # Decide which protocol stack is going to be used

    force_keepalive=yes
    keep_alive=60
    # Send a keep-alive packet every 60 seconds.

conn L2TP-PSK-noNAT
    authby=secret
    # Shared secret

    pfs=no
    # Disable pfs

    auto=add
    # The IPSec tunnel should be started and routes created when the ipsec daemon itself starts

    keyingtries=3
    # Allow connection retries 3 times

    ikelifetime=8h
    keylife=1h

    ike=aes256-sha1,aes128-sha1,3des-sha1
    phase2alg=aes256-sha1,aes128-sha1,3des-sha1
    # Specifies the phase 1 encryption scheme, the hashing algorithm, and the diffie-hellman group.

    type=transport
    # Because we use l2tp as tunnel protocol

    left=<SERVER-IP>
    # Edit your servers external IP here

    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any

    dpddelay=10
    # Dead Peer Dectection (RFC 3706) keep-alives delay
    dpdtimeout=20
    # Length of time (in seconds) we will idle without hearing either an R_U_THERE poll from our peer, or an R_U_THERE_ACK reply.
    dpdaction=clear
    # When a DPD enabled peer is declared dead, what action should be taken. clear means the eroute and SA with both be cleared.
```

Edit `/etc/ipsec.secrets` to add the shared secret:

```bash
<SERVER-IP>  %any:   PSK "**some-secret-string-here**"
```

To add VPN users, edit `/etc/ppp/chap-secrets`:

```bash
# client		servers		secret		IP addresses
username		l2tpd		password	*
```

Verify everything is okay:

```bash
$ ipsec verify
```

Check `/var/log/syslog` for error messages.
