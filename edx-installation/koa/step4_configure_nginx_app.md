# SSL Configuration
We will generate and sign our CA.
You'll receive 2 files
- virgodarth_com.crt (combine crt and ca-bundle)
- virgodarth_com.key

You copy it to server and push it in /edx/etc/ssl
```
$ sudo mkdir /edx/etc/ssl/{certs,private}
$ sudo cp virgodarth_com.crt /edx/etc/ssl/certs
$ sudo cp virgodarth_com.key /edx/etc/ssl/private
```

# Nginx Configuration
EdX Nginx Configure in /edx/app/nginx

## Site Available
### LMS
```
$ sudo vi /edx/app/nginx/sites-available/lms
```
### CMS
```
$ sudo vi /edx/app/nginx/sites-available/cms
```

### Discovery
```
$ sudo vi /edx/app/nginx/sites-available/discovery
```

### Ecommerce
```
$ sudo vi /edx/app/nginx/sites-available/ecommerce
```

### Forum
```
$ sudo vi /edx/app/nginx/sites-available/forum
```

### Analytics
```
$ sudo vi /edx/app/nginx/sites-available/analytics_api
```

### Certs
```
$ sudo vi /edx/app/nginx/sites-available/certs
```

## Check And restart Nginx Service
- Check Nginx config
```
$ sudo nginx -t
### If you see bellow text, congratulation everything is readdy ###
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

### if you see something like bellow text, don't worry, let's follow the error and fix it ###
nginx: [emerg] cannot load certificate key "/edx/etc/ssl/private/virgodarth_com.crt": BIO_new_file() failed (SSL: error:02001002:system library:fopen:No such file or directory:fopen('/edx/etc/ssl/private/virgodarth_com.crt','r') error:2006D080:BIO routines:BIO_new_file:no such file)
nginx: configuration file /etc/nginx/nginx.conf test failed
```

- Restart service
```
$ sudo service nginx restart 
-- OR --
$ sudo systemctl restart nginx.service
-- OR --
sudo /etc/init.d/nginx restart
```
