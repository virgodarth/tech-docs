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

### Change Domain

### Configure Marketing Urls -- MKTG
1. Enable MKTG
```
$ sudo vi /edx/etc/lms.yml
FEATURES['ENABLE_MKTG_SITE'] = true
```

2. Set MKT_URLS
```
$ sudo vi /edx/etc/lms.yml
MKTG_URLS: {
    'ROOT': 'https://courses.goamazing.org',
    'ABOUT': 'https://goamazing.org/about',
    'CONTACT': '/contact',
    'PRIVACY': 'https://goamazing.org/privacy',
    'TOS': 'https://goamazing.org/terms',
    'FAQ': 'https://goamazing.org/contact',
    'WHAT_IS_VERIFIED_CERT': 'verified-certificate',
    'COURSES': '/courses',
}

```

3. Prevent Homepage loop
```
$ sudo vi /edx/app/edxapp/edx-platform/lms/djangoapps/branding/views.py  # at line 53
    # if enable_mktg_site:
    #     marketing_urls = configuration_helpers.get_value(
    #         'MKTG_URLS',
    #         settings.MKTG_URLS
    #     )
    #     return redirect(marketing_urls.get('ROOT'))
```

4. Prevent courses redirect loop
```
$ sudo vi /edx/app/edxapp/edx-platform/lms/djangoapps/branding/views.py  # at line 97
    if enable_mktg_site:
        root_link = marketing_link('COURSES')
        course_link = marketing_link('COURSES')
        if not course_link.startswith(root_link):
            return redirect(permanent=True)
```


Related file:
- /edx/etc/studio.yml
- /edx/app/edxapp/edx-platform/lms/djangoapps/branding/views.py
- /edx/app/edxapp/edx-platform/common/djangoapps/edxmako/shortcuts.py

Referer:
- https://github.com/edx/edx-platform/wiki/Alternate-site-for-marketing-links

## Useful Command Vi
1. Search
```
- */keyword*: to find the occurrence of the word keyword on the file
- *Type n*: to find next matching keyword
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
