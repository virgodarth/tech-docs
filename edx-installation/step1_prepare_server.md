# Connect to server
```
$ ssh username@server.ip
```

# Update OS
## Setup locale
Set variable in ~/.profile
```
export LC_PAPER=vi_VN
export LC_ADDRESS=vi_VN
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TELEPHONE=vi_VN
export LC_IDENTIFICATION=en_US.UTF-8
export LC_MEASUREMENT=vi_VN
export LC_TIME=C.UTF-8
export LC_NAME=en_US.UTF-8
```

## Set default editor
```
echo 'export EDITOR="/usr/bin/vi"' >> ~/.profile
echo 'export VISUAL="/usr/bin/vi"' >> ~/.profile
```

## Update server
```
$ sudo apt update -y && sudo apt upgrade -y
$ sudo reboot
```

## Remove uneccessary packages
```
$ sudo apt autoremove -y
$ sudo reboot
```

# Grant User Permission
## Change password root
- Use https://passwordsgenerator.net/ to generate random password
```
$ passwd newpass
```

## Create new user
1. Add new user
```
$ sudo useradd username
```
2. Set password
```
$ sudo password username
```
3. Set up home directory
**Method 1**: use helper tool
```
$ sudo mkhomedir_helper username
```
**Method 2**: manual
- Create and grant permission for folder
```
$ sudo ls /home/  # check existed folders
$ sudo mkdir /home/username  # create new home folder
$ sudo chown username.groupname /home/username  # grant permission
```
- Set default user home
```
$ sudo usermod -d /home/username username
```

**Check permission**
```
$ grep username /etc/passwd
username:x:1000:1000::/home/username:/bin/bash  # work well and done
```

## Grant sudo permision
```
$ sudo visudo 
# Members of the admin group may gain root privileges
username ALL=(ALL) ALL  # enter permission
```

# Setup SSH
## Create ssh-key for username
```
$ sudo su username  # login as username
$ ssh-keygen -t rsa -b 4096  # execute generation
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa):  # path to private key
Created directory '/home/username/.ssh'.  # auto create ~/.ssh if doesn't exist
Enter passphrase (empty for no passphrase):  # enter pem key
Enter same passphrase again:  # re-type
Your identification has been saved in /home/username/.ssh/id_rsa.
Your public key has been saved in /home/username/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:alkdsjfljoiqwejlkfjaslbuekqjkcieoucnemqamde username
The key's randomart image is:
+---[RSA 4096]----+
|.=+o+.+ ..o... o |
|= +o.= = = .. o..|
|oo o= = + +   o .|
|o....o + + . . . |
|E.   .. S . .    |
|      .o   o     |
|      ..+ o      |
|     ..= o       |
|      ..o        |
+----[SHA256]-----+

```
## Enable login by pem file
- Copy public key (~/.ssh/id_rsa.pub) and paste it into ~/.ssh/authorized_keys
- Save private key (~/.ssh/id_rsa) on local
- Remove ~/.ssh/id_rsa.pub and ~/.ssh/id_rsa
- Login with pem key
```
$ chmod 400 private_key.pem
$ ssh -i private_key.pem username@server.ip
```

## Disable login by password and disable login by root user
```
$ sudo vi /etc/ssh/sshd_config

# Authentication:
LoginGraceTime 120
PermitRootLogin no  # change yes --> no
StrictModes yes

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no  # change yes --> no

# Change to no to disable tunnelled clear text passwords
PasswordAuthentication no  # change yes --> no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM no  # change yes --> no
```

## Change defautl ssh port
```
$ sudo vi /etc/ssh/sshd_config
# What ports, IPs and protocols we listen for
Port 22  # default 22
```

## Reload SSH config
```
$ sudo /etc/init.d/ssh reload
```

## Login with ssh
```
$ ssh -i private_key.pem username@server.ip -p port_number
```

# Installing Oracle JDK8
0. Install library
```
$ sudo apt install libc6-i386
```
1. Download JDK8 from oracle website
- https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html
2. Copy file to server
```
$ scp -i private.key -P 22 jdk8.tar.gz username@ip:/home/username/Downloads
```
3. Uncompress jdk
```
$ tar xzvf jdk8.tar.gz
```
4. Copy java directory to /opt/oraclejdk/
```
$ sudo mkdir -p /opt/oraclejdk/jdk18
$ sudo cp -r jdk1.8.0_261/* /opt/oraclejdk/jdk18
```
5. Change default JAVA_HOME environment
```
$ sudo vi /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/oraclejdk/jdk18/bin:/opt/oraclejdk/jdk18/jre/bin:/opt/oraclejdk/jdk18db/bin"
J2SDKDIR="/opt/oraclejdk/jdk18"
J2REDIR="/opt/oraclejdk/jdk18/jre"
JAVA_HOME="/opt/oraclejdk/jdk18"
DERBY_HOME="/opt/oraclejdk/jdk18/db"
```
6. Update java alternatives
```
## update-alternatives --install needs <link> <name> <path> <priority>
$ sudo update-alternatives --install "/usr/bin/java" "java" "/opt/oraclejdk/jdk18/bin/java" 0
$ sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/oraclejdk/jdk18/bin/javac" 0
$ sudo update-alternatives --set java "/opt/oraclejdk/jdk18/bin/java"
$ sudo update-alternatives --set javac "/opt/oraclejdk/jdk18/bin/javac"
```
7. Verify the setup
```
$ update-alternatives --list java
$ update-alternatives --list javac
```
8. Restart

# Backup And Restore Snapshot with Timeshift
### Installing
```
sudo apt-add-repository -y ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install timeshift
```
### CLI
1. Create a first backup simply by executing the below command: 
```
$ sudo timeshift --create
First run mode (config file not found)
Selected default snapshot type: RSYNC
Mounted /dev/sda2 at /media/root/359151f5-efb9-483d-a738-894d57e2d8c8.
Selected default snapshot device: /dev/sda2
------------------------------------------------------------------------------
Estimating system size...
Creating new snapshot...(RSYNC)
Saving to device: /dev/sda2, mounted at path: /media/root/359151f5-efb9-483d-a738-894d57e2d8c8
Synching files with rsync...
Created control file: /media/root/359151f5-efb9-483d-a738-894d57e2d8c8/timeshift/snapshots/2020-02-19_18-32-36/info.json
RSYNC Snapshot saved successfully (39s)
Tagged snapshot '2020-02-19_18-32-36': ondemand
```
2. List all your currently created system backup screenshots: 
```
$ sudo timeshift --list
Device : /dev/sda2
UUID   : 359151f5-efb9-483d-a738-894d57e2d8c8
Path   : /media/root/359151f5-efb9-483d-a738-894d57e2d8c8
Mode   : RSYNC
Device is OK
1 snapshots, 197.7 GB free

Num     Name                 Tags  Description  
------------------------------------------------------------------------------
0    >  2020-02-19_18-32-36  O 
```
3. Restore from the backup snapshot: 
```
$ sudo timeshift --restore --snapshot "2020-02-19_18-32-36"
```
4. Delete selected backup snapshot: 
```
$ sudo timeshift --delete  --snapshot '2014-10-12_16-29-08'
```
### Reference
- https://linuxconfig.org/ubuntu-20-04-system-backup-and-restore

# LVM
1. Create PV
2. Create VG
3. Create LV
4. Create Snapshot
```
$ sudo lvcreate --size 1G --snapshot --name root_snapshot /dev/vg0/root
```
5. Remove LV

# Install OpenEdx juniper
## Set up Environment
Set the OPENEDX_RELEASE variable. You choose the version of software by setting the OPENEDX_RELEASE variable before running the commands
[Edx Releases](https://edx.readthedocs.io/projects/edx-developer-docs/en/latest/named_releases.html#juniper)
```
export OPENEDX_RELEASE=open-release/juniper.2
```

