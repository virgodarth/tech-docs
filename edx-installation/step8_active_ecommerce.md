# Active Ecommerce on EdX

## Register the backend ecommerce client with OIDC/OAUTH (new and required on Juniper)
1. Go to https://<lms-server>/admin/oauth2_provider/application/
2. Click **Add client** button
3. **Client id** (ecommerce public key): The system automatically generates values
4. Choose User/ Just leave field blank
5. Redirect url: https://<ecommerce-server>/complete/edx-oauth2/
6. Client type: choose **Confidential**
7. Authorization grant type: choose **Client credentials**
8. **Client secret** (ecommerce private key): The system automatically generates values
9. Name: Backend Ecommerce Service (feeling free)

## Register the client with OIDC/OAUTH
1. Go to https://<lms-server>/admin/oauth2_provider/application/
2. Click **Add client** button
3. **Client id** (ecommerce public key): The system automatically generates values
4. Choose User/ Just leave field blank
5. Redirect url: https://<ecommerce-server>/complete/edx-oauth2/
6. Client type: choose **Confidential**
7. Authorization grant type: choose **Authorization code**
8. **Client secret** (ecommerce private key): The system automatically generates values
9. Name: Ecommerce SSO (feeling free)

## Configure ecommerce.yml
- Change LMS server
```
$ sudo vi /edx/etc/ecommerce.yml
# change example domain
:%s/example.com/<lms-domain>/

# change lms local ip to lms domain
:%s/http:\/\/127.0.0.1:8000/https:\/\/<lms-domain>/

# change ecommerce local ip to ecommerce domain
:%s/http:\/\/127.0.0.1:8002/https:\/\/<ecommerce-domain>/
```

- SSL Secure
```
SESSION_COOKIE_SECURE: true
SESSION_EXPIRE_AT_BROWSER_CLOSE: true
CSRF_COOKIE_SECURE: true
CORS_ALLOW_CREDENTIALS: false
CORS_ORIGIN_WHITELIST: ['somedomain.ok']
```

- Authorization between servers
```
EDX_API_KEY: <your key>

# Ecommence SSO
SOCIAL_AUTH_EDX_OAUTH2_KEY: <sso-client-id>
SOCIAL_AUTH_EDX_OAUTH2_SECRET: <sso-client-secret>
SOCIAL_AUTH_REDIRECT_IS_HTTPS: true

# Backend Ecommerce
BACKEND_SERVICE_EDX_OAUTH2_KEY: <backend-client-id>
BACKEND_SERVICE_EDX_OAUTH2_SECRET: <backend-client-secret>
```

- Restart Service
```
$ sudo /edx/bin/super
```

## Enable Commerce Service on LMS
1. Go to **https://<lms-server>/admin/ecommerce/commerceconfiguration**
2. Click **Add Comerce Configuration** button
3. Check **Enabled**
4. Check **Checkout on ecommerce service**
5. Basket checkout page: /basket/add/
6. Cache Time To Live: 300 (= 5 mins)
7. Receipt page: /checkout/receipt/?order_number=
8. Save

## Configure Oscar Ecommerce
```
$ sudo su ecommerce -s /bin/bash  # login as ecommerce user
$ cd ~/ecommerce  # move to ecommerce app
$ source ../ecommerce_env  # active environment

$ python manage.py makemigrations  # make sure database initiated
$ python manage.py migrate

# update setting
$ python manage.py create_or_update_site \
    --site-id=1 \  # Get id from django.Site
    --site-domain=<site-domain> \
    --partner-code=VD \  # default. If you want to change it, you can access ecommerce.partner_partner tables and update the code
    --partner-name=VirgoDarth \
    --lms-url-root=https://<lms-server> \
    --payment-processors=cybersource,paypal \  # allow 3 methods: paypal, cybersource, stripe
    --sso-client-id=orR3s5dyMwypEMLx2h1wwWh8Mr6c586fwJihpZ76 \
    --sso-client-secret=8sahDxBuV52eQw8LfI3eKZfUwJrNvRaO7nGTXLsxrKerM3zaDZVGnxwGbXOOAczTBdspfizLLXAwHYCSE9nMfOkPCI7iFGR829MHWf2FgLk5DQO1enMzlHdpzfNYsKqA \
    --backend-service-client-id=uTMwcAOn2ewlz7o2y3mWlhphjFyPCrRqfjaw43gn \
    --backend-service-client-secret=91FFfBfmPNjixfIBStopeOwVkhWjgOfmdBURRjuBALSJtMwgpaQ9q1dAn4t1Q0d1nDRDUFdeJpm0Pa0Aa31uanlRLtFw5RnjZnl2NfLRyY0IV3MKLFxmp2x5oiS5ThM7 \
    --lms-public-url-root=https://<lms-server> \
    --base-cookie-domain=<base-domain> \
    --discovery_api_url=https://<discovery-server> \
    --from-email=virgodarth@gmail.com
```

## Configure EcommerWorker
```
$ sudo vi /edx/etc/ecommerworker.yml
:%s/http:\/\/127.0.0.1:8002/https:\/\/<ecommerce-server>/
```

## Restart services
```
$ sudo /edx/bin/supervisorctl restart ecommerce ecomworker
```

## Configure Paypal Gateway

## Configure Cybersource Gateway

## Configure Striipe Gateway

## Problem Solving
1. Missing requiremtnt fields when run create_or_update_site
```
$ python manage.py create_or_update_site ...
manage.py create_or_update_site: error: the following arguments are required: --lms-url-root, --sso-client-id, --sso-client-secret, --backend-service-client-id, --backend-service-client-secret, --from-email, --discovery_api_url
```
- *Reason*: lms-url-root, sso-client-id, sso-client-secret, backend-service-client-id, backend-service-client-secret, from-email, discovery_api_url: requiremt fields
- *Solving*: you have to add field when run script

2. Duplicate default_site_id entry when run create_or_update_site
```
$ python manage.py create_or_update_site ...
MySQLdb._exceptions.IntegrityError: (1062, "Duplicate entry '1' for key 'default_site_id'")
```
- *Reason*: EdX set partner code default=edX with default site=1, but you try to create a new partner (partner-code different *edX*) with the same default_site_id (=1, unique constrain)
- *Solving*:
  - Method 1: Use edX code as default
  - Method 2: create a new django Site, set site-id which get when create new Site
  ```
  $ mysql -uecomm001 -p <your-password>
  mysql> insert into ecommerce.django_site (Domain, Name) values ('<your-domain>', '<display-name>')'
  ```
  - Method 3: access ecommerce.partner_partner tables and update code
  ```
  $ mysql -uecomm001 -p <your-password>
  mysql> update ecommerce.part_nr_partner set Code='<your-code>' where code='edX';
  ```

3. Ecommerce Dashboard auto redirect LMS Dasboard, although the account's admin permission
- *Reason*: Your account don't have admin permission on Ecommerce. Sometime, ecommece server can't sync the same permision on LMS
- *Solving*: Manual grant admin permission
```
$ mysql -uecomm001 -p <your-password>
mysql> update ecommerce.ecommerce_user set is_superuser=1, is_staff=1 where username='<your-username>';
```

4. 404 - Page not found
You can't access your ecommerce server
- *Reason*: diff port between nginx (port=18130) and ecommerce (port=8002) configure.
- *Solving*: make sure nginx and ecommerce app using the same port

# Related files
- /edx/app/ecommerce/ecommerce/ecommerce/core/management/commands/create_or_update_site.py

# Related table on ecommerce database
- django_site
- partner_partner
- core_siteconfiguration
- ecommerce_user

# Referer
- [How to Install And Start Ecommerce Service](https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/110330276/How+to+Install+and+Start+the+E-Commerce+Service+in+Native+Installations)
- [Install Ecommerce Open Edx](https://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/latest/ecommerce/install_ecommerce.html)
- [Oauth2 Grant Types](https://docs.pivotal.io/p-identity/1-11/grant-types.html)
