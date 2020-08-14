# How To Work With SSL Certificates
## Overview
- Common Name (Server Name): The fully qualified domain name that clients will use to reach your server.
Example:
-- Single Domain: virgodarth.com, ssl.virgodarth.com
-- Wildcard certificate: \*.virgodarth.com

- Organization name: The exact legal name of your organization, (e.g. VirgoGroup Inc.). If you do not have a legal registered organization name, you should enter your own full name here.

- [Optional] Department: This is the department within your organization that you want to appear on the certificate. It will be listed in the certificate's subject as Organizational Unit, or "OU".

- City: The city where your organization is legally located. 

- State or Province: The state or province where your organization is legally located. 

- Country: your country. Example: Vietnam.

- Key: RSA Key sizes smaller than 2048 are considered unsecure.

## Branches
### Common branches
- Sectigo / Comodo
- OneSignSSL
- Symantec
- DigiCert
- Geotrust
- Thawte
- RapidSSL
- GlobalSign
- Digicert

### Cheap Providers
- [MuaSSL.vn](https://muassl.com)
- [NameCheap.com](https://www.namecheap.com/)

## How To Create An SSL
### [Optional] Online generate
- Use [Digicert Tool](https://www.digicert.com/easy-csr/openssl.htm) to generate openssl script

### Create CSR and Private key
Create cert and private key. Use openssl command to create keys. After execute command we get 2 files: virgodarth_com.csr (send provider server), virgodarth_com.crt (private key, don't share anyone).
```
openssl req -new -newkey rsa:2048 -nodes -out virgodarth_com.csr -keyout virgodarth_com.key -subj "/C=VN/ST=Ho Chi Minh/L=District 10/O=Virgo Group/CN=virgodarth.com"
```
params:
- req (req): PKCS#10 X.509 Certificate Signing Request (CSR) Management.
- new (-new): This option generates a new certificate request.
- newkey (-newkey arg): This option creates a new certificate request and a new private key. The argument takes one of several forms *rsa:nbits*
- keyout (-keyout filename): This gives the filename to write the newly created private key to.
- subj (-subj arg): Sets subject name for new request or supersedes the subject name when processing a request. The arg must be formatted as */type0=value0/type1=value1/type2=...*, characters may be escaped by \ (backslash), no spaces are skipped.

### Sign CSR
1. **Require**: Send your certificate to provider. Ex: virgodarth_com.csr

2. **Validate**: Provider server will ask you verify your domain name. We have 3 ways to verify it (whois)
- Email validate: Enter your admin email and provider will send you a verify link to admin email. Just click and done. Example: admin@virgodarth.com *(recommend)*, administrator@virgodarth.com, webmaster@virgodarth.com, hostmaster@virgodarth.com, postmaster@virgodarth.com
- DNS validate: Create a CNAME record with params provided by provider. 
- FILE validate [HTTP/ HTTPS]: Provider provide you an file.txt and full url verify, you had to upload it on your server with exactly the link. Ex: https://virgodarth.com/.well-known/pki-validation/40B25F4C2C19AE30187FE6CBE96E9F51.txt

3. **Confirm**: provider will send you 2 files: virgodarth_com.crt, virgodarth_com.ca-bundle

### Let's Trust SSL

### Self-sign SSL
If you don't have plan on your certificate signed by a CA, we will generate a self-signed certificates.
This step we will self-sign for own certificate (\*.crt)
```
openssl x509 -req -days 365 -in virgodart_com.csr -signkey virgodarth_com.key -out virgodarth_com.crt
```

### Prepairn to install SSL on Own Server
1. Nginx Server: Combine crt and ca-bundle file
```
cat virgodarth_com.crt virgodarth_com.ca-bundle > virgodarth_com_ca.crt
```

2. IIS: create pfx file
Create pfx file to upload IIS
```
openssl pkcs12 -export -out virgodarth_com.pfx -inkey virgodarth_com.key -in virgodarth_com_ca.crt
Enter Export Password:  # enter your password
Verifying - Enter Export Password:  # retype
```

3. Apache Server:
Do nothing
