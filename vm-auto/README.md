## Setup

1. To run this script automatically. Clone this repo go into vm-auto directory.
2. Execute this command for creating server

```bash
./script.sh init
```

This will create the ec2 instance on aws console.

3. Now this script will also paste the public static ip of vm into the ip.txt file copy that ip and point that ip in cloudflare subdomain.

4. Now execute below command to install ghost

```bash
./script.sh install
```

5. Now this command will ask for domain_name, email_id provide it and you are good to go :)

#### terraform.tfvars file

vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.0.0/24"
avail_zone = "ap-south-1a"
env_prefix = "dev"
my_ip = "0.0.0.0/0"
instance_type = "t2.micro"
