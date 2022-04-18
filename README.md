# Ghost CMS + Docker Compose

These are some reassons why use this Docker Compose in your production environment.

☝️ 1 command to install

👨‍💻 Ready to production

⚡ Performance Optimized

🔒 SSL auto-renewed

## Stack

- Ubuntu 20.04 LTS or Centos 8
- Ghost CMS lastest docker image(alpine)
- mysqlDB latest docker image
- Nginx latest docker image(alpine)
- Letsencrypt latest docker image
- Docker
- Docker-compose

## How start using this source?

Make sure that your `domain` and `domain` are pointing to your server IP.

| Type | Name       | Content         |
| ---- | ---------- | --------------- |
| A    | domain.com | 123.123.123.123 |

Then copy this command below and **change the mydomain.com to your domain** and **change the email@email.com to your email address** and run it inside your new server.

### For Ubuntu 20.04 LTS users

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt install curl git cron -y && sudo apt autoremove -y
```

Use pre-installed docker machine

```bash
curl -s https://raw.githubusercontent.com/Alt-Ghost/altghost-devops/master/dc | bash -s setup mydomain.com email@email.com
```

Use without installed docker machine

```bash
curl -s https://raw.githubusercontent.com/Alt-Ghost/altghost-devops/master/dcsimple | bash -s setup mydomain.com email@email.com
```

## Commands

| Commands      | Description                              |
| ------------- | ---------------------------------------- |
| `./dc start`  | Start your containers                    |
| `./dc stop`   | Stop all containers                      |
| `./dc update` | Get Ghost updates and restart containers |

Thank you all [contributor](https://github.com/clean-docker/ghost-cms/graphs/contributors)!
