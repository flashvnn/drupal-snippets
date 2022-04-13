## ERROR umount: /mnt: not mounted

```
Error: Nothing to do
Unmounting Virtualbox Guest Additions ISO from: /mnt
umount: /mnt: not mounted
==> servernfs: Checking for guest additions in VM...
    servernfs: No guest additions were detected on the base box for this VM! Guest
    servernfs: additions are required for forwarded ports, shared folders, host only
    servernfs: networking, and more. If SSH fails on this machine, please install
    servernfs: the guest additions and repackage the box to continue.
    servernfs:
    servernfs: This is not an error message; everything may continue to work properly,
    servernfs: in which case you may ignore this message.
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

umount /mnt

Stdout from the command:



Stderr from the command:

umount: /mnt: not mounted
```

Fix with
```
vagrant plugin uninstall vagrant-vbguest
vagrant plugin install vagrant-vbguest --plugin-version 0.21
```

