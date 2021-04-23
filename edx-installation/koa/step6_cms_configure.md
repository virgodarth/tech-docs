# LMS And CMS Configuration
## Create Staff user
```
# login as edxapp user
$ sudo su edxapp -s /bin/bash
$ cd /edx/app/edxapp/edx-platform  # change wordir. Another way: $ cd ~/edx-platform

# Active environment
$ source ../edxapp_env
$ which python
/edx/app/edxapp/venvs/edxapp/bin/python  # active successfully environment 

# create user as staff
$ python manage.py lms manage_user admin admin@virgodarth.com --staff --superuser --settings=production

# change password
$ python manage.py lms changepassword admin --settings=production
Changing password for user 'admin'
Password:
Password (again):
Password changed successfully for user 'admin'
```

## Configure LMS env
1. LMS environment: /edx/app/edxapp/lms.env.json
```
$ vi /edx/app/edxapp/lms.env.json
```

2. LMS Authentication: /edx/app/edxapp/lms.auth.json

## Configure CMS env
1. CMS environment: /edx/app/edxapp/cms.env.json
```
$ vi /edx/app/edxapp/cms.env.json
```

2. CMS Authentication: /edx/app/edxapp/cms.auth.json
```
$ vi /edx/app/edxapp/cms.auth.json
```

## Folders
- App Sources and Environments: /edx/app
- Service Configure: /edx/etc
- Executive Scripts: /edx/bin
- Static: /edx/var
- Logs: /edx/var/logs


# Referer
- [Manageing the Server](https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+Open+edX+Tips+and+Tricks)
