# Ghost CMS + Docker Compose
These are some reassons why use this Docker Compose in your production environment.

### 1 command to install

### Ready to production

### Performance Optimized

### SSL auto-renewed

<hr>

### Used Stack

1. Ubuntu 20.04 LTS
2. Ghost CMS lastest docker image(alpine)
3. MySQL 8 docker image
4. Caddy 2.23 docker image(alpine)
5. Docker-compose


### Automation 

1. Create Vm on aws
```bash
./script.sh vmcreate
```

2. Point VM ip to our subdomain.

3. Install ghost with script
```bash
./script.sh vminstall
```
This will ask you domain at the time of creation.

4. And done. It will create ghost with mysql and ssl.

5. For updating domain name. Give IP of the vm to user to point it to domain address then you have to SSH into VM then follow below command.
```bash
./script.sh domainupdate
```
Execute this then it will ask old domain address then it will ask for new domain address do that and we are good to go.
