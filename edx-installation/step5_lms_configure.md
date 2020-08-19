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
**Juniper** ha
1. LMS environment: /edx/app/edxapp/lms.env.json
```
$ vi /edx/app/edxapp/lms.env.json
```

2. LMS Authentication: /edx/app/edxapp/lms.auth.json

1. MKTG_URLS: Marketing URL
```
djangoapps/branding/views.py
```

## Useful Command Vi
1. Search
```
```

2. Replace
- *:s/foo/bar/*: to replace the first occurrence of the word foo on the current line with the word bar.
- *:s/foo/bar/g* to replace all occurrences of the word foo on the current line with the word bar.
- *:%s/foo/bar/g* to replace all occurrences of the word foo in the current file with the word bar. Leaving off the g at the end only replaces the first occurrence of foo on each line of the current file.
- *:%s/foo//g* to delete all occurrences of the word foo in the current file. Leaving off the percent sign (%), of course, only does this for the current line.
- *:%s/foo/bar/gc* to have Vi query you before each attempt to replace the word foo with the word bar.
```

3. Undo/Redo
- *:u*/ *:undo N*/ *Type u*: undo text
- *Ctrl + R*: redo text

## Folders
- App Sources and Environments: /edx/app
- Service Configure: /edx/etc
- Executive Scripts: /edx/bin
- Static: /edx/var
- Logs: /edx/var/logs


# Referer
- [Manageing the Server](https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/60227913/Managing+Open+edX+Tips+and+Tricks)
