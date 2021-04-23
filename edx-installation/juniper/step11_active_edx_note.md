# Active Student Notes on EdXa

## Install Student Notes Repo using ansible
1. Add # comment out aws role in ansible roles
```
$ sudo vi /edx/app/edx_ansible/edx_ansible/playbooks/notes.yml
# comment role: aws and follow lines if has
#    - role: aws
#      when: COMMON_ENABLE_AWS_ROLE
```

2. Activate ansible enviroment
```
$ source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate
```

3. Auto clone and install edx repo from github
```
$ cd /edx/app/edx_ansible/edx_ansible/playbooks
$ sudo ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=edxlocal' -e@roles/edx_notes_api/defaults/main.yml
$ sudo ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=edx_notes_api' -e@roles/edx_notes_api/defaults/main.yml
```

4. Test
when you completed above commands (one or two minutes), some properties should have
```
# Check edx_notes_api app dir
$ ls /edx/app/edx_notes_api/

# Check edx_notes_api config file
$ ls /edx/etc/edx_notes_api.yml

# Check edx_notes_api nginx config
$ ls /edx/app/nginx/sites-available/edx_notes_api

# check supervisorctl config
$ sudo /edx/bin/supervisorctl status edx_notes_api
edx_notes_api                    RUNNING   pid 1935, uptime 3:48:10
```

## Register the client with OIDC/OAUTH
Similar discovery and ecommerce, we will create credential for edx note

1. Go to https://<lms-server>/admin/oauth2_provider/application/
2. Click **Add client** button
3. **Client id** (ecommerce public key): The system automatically generates values
4. Choose User/ Just leave field blank
5. Redirect url: https://<edx-notes-server>/complete/edx-oauth2/
6. Client type: choose **Confidential**
7. Authorization grant type: choose **Authorization code**
8. **Client secret** (ecommerce private key): The system automatically generates values
9. Name: **edx-notes** (edx hardcoded this name)

## Configure edx_notes_api nginx (optional)
You can change server name and add ssl
```
$ sudo vi /edx/app/nginx/sites-available/edx_notes_api
server {
  listen 18120 ssl;
  ssl_certificate /edx/etc/ssl/certs/star_goamazing_org_ca.crt;
  ssl_certificate_key /edx/etc/ssl/private/star_goamazing_org.key;
  server_name ~^((stage|prod)-)?notes.*;
  ...
}
```

## Configure edx_notes_api.yml
At this step, we will enable oauth between LMS and EdX note

There some steps we need to change in /edx/etc/edx_notes_api.yml file.

1. Update allow host
```
ALLOWED_HOSTS:
- localhost
- <lms-server-domain>
- <edx-notes-server-domain>
```

2. LMS OAuth
```
CLIENT_ID: <client-oauth2>  # created above step
CLIENT_SECRET: <secret-oauth2>  # created above step
```

3. Update database user's password
```
DATABASES:
  default:
    PASSWORD: <strong-password>
```

3 Authorization between servers
```
SECRET_KEY: <edx-api-key>  # get from lms.yml config file
```

4. Configure JWT
Keys got from lms.yml config file.
```
JWT_AUTH:
  JWT_ISSUERS:
    AUDIENCE: <audience-key>  
    ISSUER: https://<lms-server>/oauth2
    SECRET_KEY: <jwt-generate-private-key>
  JWT_PUBLIC_SIGNING_JWK_SET: <jwt-generate-public-key>
```

5. Update User worker
- Create note_woker on LMS admin
```
USERNAME_REPLACEMENT_WORKER: <note_worker>
```

5. Restart Service
```
$ sudo /edx/bin/supervisorctl restart edx_notes_api
```

## Enable EdX Note front-end on LMS
1. We'll edit the LMS environment configuration to enable Notes in the front-end (/edx/etc/lms.yml)
```
EDXNOTES_INTERNAL_API: <edx-note-server>
EDXNOTES_PUBLIC_API: <edx-note-server>
FEATURES:
  ENABLE_EDXNOTES: true
```

2. We also change CMS environment configuration
```
FEATURES:
  ENABLE_EDXNOTES: true
```

3. Restart services
```
sudo /edx/bin/supervisorctl restart lms cms
```

4. The course has to be enabled note on CMS page
- Go to the courses
- Click **Settings > Advanced Settings**
- change **Enable Student Notes** to **true**
- Save Changes.

## Migrate DB
1. Update User Password
```
$ sudo mysql
mysql> use mysql;
mysql> SET PASSWORD FOR 'notes001'@'localhost' = PASSWORD('strong-password');  # change mysql note's password
```

2. Update note permission to allow migrating edx_notes_api database
```
mysql> GRANT ALL PRIVILEGES ON `edx_notes_api`.* TO 'notes001'@'localhost'
```

3. Change to edx_notes_api user
```
$ sudo su edx_notes_api -s /bin/bash
$ cd ~/edx_notes_api/
$ source ../edx_notes_api_env
```

4. Change edx note tags
By default config in /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml file, ansible will auto checkout master branch (EDX_NOTES_API_VERSION: master). 
And LMS will incompatible with EdX Notes.

Therefore, we will brach which edx-platform's using
```
$ git fetch --all --tags
$ git checkout tags/open-release/juniper.3  # you can change the tag name as you go
```

5. Update requirements for pip
```
$ make requirements
```

6. Rebuild ElasticSearch for edx_note
```
$ make create-index
```

7. Migrate database
```
$ make migrate
```

## Restart services
```
$ sudo /edx/bin/supervisorctl restart lms cms edx_notes_api
```

## Problem Solving

# Referer
- [Install Open edX Notes & Annotations By Lawrence McDaniel](https://blog.lawrencemcdaniel.com/open-edx-notes/)
- [Open Note Discussion](https://discuss.openedx.org/t/open-edx-notes-installation/1000/7)
