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

## Fix Vagrant ssl error

```
// Add this line
Vagrant.configure("2") do |config|
  config.vm.box_download_insecure =true
  
```  

## JSON ParserError when meta file is malformed

Delete folder __.vagrant__ where has file __Vagrantfile__

## Run vagrant ansible provision with params

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
 
Vagrant.configure("2") do |config|
    ...
    config.vm.provision "ansible" do |ansible|
        ...
        ansible.playbook = "provisioning/site.yml"
        ansible.raw_arguments = Shellwords.shellsplit(ENV["ANSIBLE_ARGS"]) if ENV["ANSIBLE_ARGS"]
        ...
    end
    ...
end

```

__Example__

```php
# If running first time, runs all tasks within provisioning otherwise just starts the VM and ignores all tasks
$ vagrant up
 
# Runs all tasks within provisioning without restarting the VM
$ vagrant provision
 
# Does not run provisioning but restarts the VM
$ vagrant reload
 
# Runs all tasks within provisioning with restarting the VM
$ vagrant reload --provision
 
# If running first time, runs tasks for given tags within provisioning otherwise just starts the VM and ignores all tasks.
$ ANSIBLE_ARGS='--tags "tag_1,tag_2,..."' vagrant up
 
# Runs tasks for given tags within provisioning without restarting the VM
$ ANSIBLE_ARGS='--tags "tag_1,tag_2,..."' vagrant provision
 
# Runs tasks for given tags within provisioning with restarting the VM
$ ANSIBLE_ARGS='--tags "tag_1,tag_2,..."' vagrant reload --provision
 
# You can also use other tags like below
$ ANSIBLE_ARGS='--skip-tags "tag_1,tag_2,..."' vagrant ...
```
