# Install OpenEdx Koa
## System Requirements
- Ubuntu 20.04 amd64
- Minimum 8GB of memory
- At least one 2.00GHz CPU or EC2 compute unit
- Minimum 25GB of free disk, 50GB recommended for production servers
Note: For hosting in Amazon we recommend an t2.large with at least a 50Gb EBS volume, see https://aws.amazon.com/ec2/pricing. Community Ubuntu AMIs have 8GB on the root directory, make sure to expand it before installing.

## Build OpenEdx Server
0. Install extra packages
```
$ sudo apt install python3-pip
$ sudo pip3 install launchpadlib=1.10.13
```

1. Setup Environment
Set the OPENEDX_RELEASE variable. You choose the version of software by setting the OPENEDX_RELEASE variable before running the commands
[Edx Releases](https://edx.readthedocs.io/projects/edx-developer-docs/en/latest/named_releases.html#juniper)
```
$ export OPENEDX_RELEASE=open-release/koa.master
$ echo $OPENEDX_RELEASE  # check envirment variable
open-release/koa.master  # work well
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
This step will generate a **my-passwords.yml** file. The file store password of MySQL, MongoDB, RabitMQ, etc. And you need save it carefully.
If this is to replace an older installation, copy your **my-passwords.yml** file from that installation.
If this is a new installation: 
```
$ wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash
$ ls
config.yml  my-passwords.yml  passwords-template.yml
```

5. Install the Open edX software.
This command also require root permission
This can take some time, perhaps an hour or more: 
```
$ wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash
...
RUNNING HANDLER [nginx : reload nginx] *****************************************
changed: [localhost]

RUNNING HANDLER [forum : restart the forum service] ****************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=678  changed=475  unreachable=0    failed=0

Installation finished at 2020-08-12 23:04:26  # well done

```

6. Check Services
```
$ sudo /edx/bin/supervisorctl status
analytics_api                    RUNNING   pid 2159, uptime 0:02:01
certs                            RUNNING   pid 2158, uptime 0:02:01
cms                              RUNNING   pid 2175, uptime 0:02:01
discovery                        RUNNING   pid 2183, uptime 0:02:01
ecommerce                        RUNNING   pid 2176, uptime 0:02:01
ecomworker                       RUNNING   pid 2153, uptime 0:02:01
edxapp_worker:cms_default_1      RUNNING   pid 2177, uptime 0:02:01
edxapp_worker:cms_high_1         RUNNING   pid 2178, uptime 0:02:01
edxapp_worker:lms_default_1      RUNNING   pid 2182, uptime 0:02:01
edxapp_worker:lms_high_1         RUNNING   pid 2181, uptime 0:02:01
edxapp_worker:lms_high_mem_1     RUNNING   pid 2180, uptime 0:02:01
forum                            RUNNING   pid 2154, uptime 0:02:01
insights                         RUNNING   pid 2174, uptime 0:02:01
lms                              RUNNING   pid 2157, uptime 0:02:01
notifier-celery-workers          RUNNING   pid 2156, uptime 0:02:01
notifier-scheduler               RUNNING   pid 2171, uptime 0:02:01
xqueue                           RUNNING   pid 2152, uptime 0:02:01
xqueue_consumer                  RUNNING   pid 2160, uptime 0:02:01
```

## Bad Suggestions (Arbitrary Upgrades)
Some Open edX components are outdated. If you see a message suggesting that you update something manually, don't do it -- something is probably relying on the outdated software remaining at that older version. 
**Don't do** bellow commands
- *do-release-upgrade*: Ubuntu may alert you that a newer version of Ubuntu available when you SSH in to your server, and may suggest that you run do-release-upgrade to upgrade to that newer version. Don't do it.
- *pip install --upgrade pip*: Pip may alert you that there is a newer version of pip available, and may suggest that you run pip install --upgrade pip to install it. Don't do it.

# Referer:
1. [Native OpenEdX Platform Ubuntu 16.04 Installation](https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/146440579/Native+Open+edX+platform+Ubuntu+16.04+64+bit+Installation)
