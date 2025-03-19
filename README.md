# fms-server-lets-encrypt
An automated script that will renew your SSL certificates using Let's Encrypt for your Filemaker Server running on Ubuntu

If you don't have certbot, install it:

```
apt-get install certbot
```

### IMPORTANT: Your filemaker server web admin interface must be accessible from the outside for this to work, because LE needs to access it to generate the SSL. You probably wouldn't care about SSL if it wasn't publicly accessible.

Put the two files in /root/ of your server

make them executable:

```
chmod +x get-ssl*
```

### IMPORTANT: Update the variables in get-ssl.sh with your domainname, email, password

add a crontab to run the script (crontab -e)

```
0 3 * * * /root/get-ssl.sh
```
