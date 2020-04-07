# ops
Infra as Code - Main repository for Smtx's automation scripts.

This environment is only accessible through the bastion instance: `bastion`.

## How to access it

Access the Bastion using key using `ssh ec2-user@ip -A`
1. after access bastion you can access ec2 app 


### Getting the Repos used for this environment
```shell
git clone https://github.com/mbaetaoliveira/ops.git
git clone https://github.com/mbaetaoliveira/flask.git
```
Now you have a clone of this repo and may apply environment changes.

### Managing AWS resources

You need to have `awscli` and `terraform` available and pre-configured for the with environment with your permissions.


### RESUME

00-state - create bucket and create file with all informations about terraform(like backup)

02-network - create vpc and subnets public and privates

03-bastion - create server bastion in the public subnet, security group with rules and public IP

04-ecr - repositorie to build/image
