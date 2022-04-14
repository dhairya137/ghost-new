### Manual Deployment with docker

1. Install docker in vm.
2. Connect IP of vm to domain name.
3. Create docker-compose.yml in vm.
4. Paste our docker-compose.yml file content in that and change url to your domain name.
5. Run this command 
```console
   docker-compose up -d
   ```
6. Configure NGINX now
7. Create file
```console 
  sudo nano /etc/nginx/sites-available/domainname.com
  ```
8. Add this content in the file
```console 
  server {
    server_name domainname;
    index index.html index.htm;
    access_log /var/log/nginx/blog.log;
    error_log  /var/log/nginx/blog-error.log error;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_pass http://127.0.0.1:8080;
        proxy_redirect off;
    }
}
  ```
9. Enable this configuration
```console
sudo ln -s /etc/nginx/sites-available/domainname.com /etc/nginx/sites-enabled/domainname.com
```
10. Check nginx configuration and reload nginx
```console
sudo nginx -t
sudo nginx -s reload 
```
11. Setup SSL on domain name
```console
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d domainname.com
sudo nginx -s reload
```

### And done you can go to your domain name and ghost site will be running
