# Install OpenEdx juniper
## System Requirements
- Ubuntu 16.04 amd64 (only support -- juniper or early)
- Minimum 8GB of memory
- At least one 2.00GHz CPU or EC2 compute unit
- Minimum 25GB of free disk, 50GB recommended for production servers
Note: For hosting in Amazon we recommend an t2.large with at least a 50Gb EBS volume, see https://aws.amazon.com/ec2/pricing. Community Ubuntu AMIs have 8GB on the root directory, make sure to expand it before installing.

## Build OpenEdx Server
1. Setup Environment
Set the OPENEDX_RELEASE variable. You choose the version of software by setting the OPENEDX_RELEASE variable before running the commands
[Edx Releases](https://edx.readthedocs.io/projects/edx-developer-docs/en/latest/named_releases.html#juniper)
```
$ export OPENEDX_RELEASE=open-release/juniper.2
$ echo $OPENEDX_RELEASE  # check envirment variable
open-release/juniper.2  # work well
```

2. Create Configuration file
Create a **config.yml** file.
This file specifies the hostname (and port, if needed) of the LMS and Studio.
Create a file in the current directory named config.yml, like this:
```
# The host names of LMS and Studio. Don't include the "https://" part:
EDXAPP_LMS_BASE: "lms.virgodarth.org"
EDXAPP_CMS_BASE: "cms.virgodarth.org"
EDXAPP_SESSION_COOKIE_DOMAIN: "virgodarth.org"
```

3. Bootstrap the Ansible installation
This step require root permision. 
```
$ wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/ansible-bootstrap.sh -O - | sudo -E bash
--2020-08-12 21:42:46--  https://raw.githubusercontent.com/edx/configuration/open-release/juniper.2/util/install/ansible-bootstrap.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.0.133, 151.101.64.133, 151.101.128.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.0.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4836 (4.7K) [text/plain]
Saving to: ‘STDOUT’

-                                                  100%[================================================================================================================>]   4.72K  --.-KB/s    in 0s

2020-08-12 21:42:47 (119 MB/s) - written to stdout [4836/4836]
#######IT CAN FREEZE RIGHT HERE#########

Sorry, try again.
[sudo] password for virgodarth:  ##########ENTER YOUR PASSWORD########
+ [[ -z '' ]]
+ ANSIBLE_REPO=https://github.com/edx/ansible.git
+ [[ -z '' ]]
+ ANSIBLE_VERSION=master
+ [[ -z '' ]]
+ CONFIGURATION_REPO=https://github.com/edx/configuration.git
+ [[ -z '' ]]
+ CONFIGURATION_VERSION=open-release/juniper.2
+ [[ -z '' ]]
+ UPGRADE_OS=false

########WAIT AND WAIT. THIS CAN TAKE 10 MINUTES##########
TASK [edx_ansible : Create a symlink for the playbooks dir] ********************
changed: [127.0.0.1]

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=39   changed=30   unreachable=0    failed=0   

+ rm -rf /tmp/ansible
+ rm -rf /tmp/configuration
+ rm -rf /tmp/bootstrap
+ rm -rf /home/goamazing/.ansible
+ cat
    ******************************************************************************

    Done bootstrapping, edx_ansible is now installed in /edx/app/edx_ansible.
    Time to run some plays.  Activate the virtual env with

    > . /edx/app/edx_ansible/venvs/edx_ansible/bin/activate

    ******************************************************************************
```

4. Randomize passwords.
This step will generate a **my-passwords.yml** file. This file store password of MySQL, MongoDB, RabitMQ, etc. And you need save it carefully.
If this is to replace an older installation, copy your **my-passwords.yml** file from that installation.
If this is a new installation: 
```
$ wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash
$ ls
config.yml  my-passwords.yml  passwords-template.yml
```

5. Install the Open edX software.
This command also requiremnt root permission
This can take some time, perhaps an hour or more: 
```
$ wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash
```

## Bad Suggestions (Arbitrary Upgrades)
Some Open edX components are outdated. If you see a message suggesting that you update something manually, don't do it -- something is probably relying on the outdated software remaining at that older version. 
**Don't do** bellow commands
- *do-release-upgrade*: Ubuntu may alert you that a newer version of Ubuntu available when you SSH in to your server, and may suggest that you run do-release-upgrade to upgrade to that newer version. Don't do it.
- *pip install --upgrade pip*: Pip may alert you that there is a newer version of pip available, and may suggest that you run pip install --upgrade pip to install it. Don't do it.

# Referer:
1. [Native OpenEdX Platform Ubuntu 16.04 Installation](https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/146440579/Native+Open+edX+platform+Ubuntu+16.04+64+bit+Installation)
