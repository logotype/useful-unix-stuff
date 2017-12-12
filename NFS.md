Shared NFS drive (Ubuntu 16.04 LTS)
===================================

Server
------

Install services (on the server):

```bash
$ sudo apt-get install nfs-kernel-server
$ sudo systemctl enable nfs-kernel-server.service
$ sudo systemctl start nfs-kernel-server.service
```

Edit `/etc/exports`:

```bash
/nfsdisk 10.0.1.0/24(rw,sync,fsid=0,no_root_squash,crossmnt,no_subtree_check,no_acl)
```

Verify configuration:

```bash
$ exportfs -rv
$ exportfs -a
$ sudo systemctl restart nfs-kernel-server.service
```

Clients
-------

Install services (on each client):

```bash
$ sudo apt install nfs-common
```

Mount the drive:

```bash
$ sudo mkdir /nfsdisk
$ sudo mount <SERVER-IP>:/nfsdisk /nfsdisk
```

Mount the drive at boot, edit `/etc/fstab`:

```bash
<SERVER-IP>:/nfsdisk /nfsdisk nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```
