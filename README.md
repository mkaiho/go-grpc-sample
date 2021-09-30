# go-grpc-sample

## Build

```.sh
make build-example
```

### Set environment variables for app

```.sh
# if it is not set, "localhost" is used as default
export API_REQUEST_HOST=<Server host>
# if it is not set, "3000" is used as default
export API_REQUEST_PORT=<Server listening port>
```

## Start server

```.sh
./build/example_server
```

## Execute client request

```.sh
# When you request to EC2 server, you need to set server host and port in environment variables API_REQUEST_HOST and API_REQUEST_PORT
./build/example_client
```

## Deploy EC2

### Prerequisite

- AWS Account has created already
- The domain has already been acquired
- Host Zone at Route53 has already been created and configured.

### Set aws configuration

```.sh
# AWS Access Key ID [None]: <your access key id>
# AWS Secret Access Key [None]: <your secret access key>
# Default region name [None]: ap-northeast-1
# Default output format [None]: json
aws configure
```

### Generate ssh key to connect ec2 instance

```.sh
ssh-keygen -t rsa -m PEM -f ./.ssh/<your key name>
```

### Register ssh key at local

```.sh
ssh-add ./.ssh/<your private key name>
```

### Set environment variables for terraform parameters

```.sh
export TF_VAR_webapp_1a_key_name=<your key pair name to connect EC2 instance>
export TF_VAR_webapp_1a_ssh_public_key=$(cat ./.ssh/<your public key name>)
export TF_VAR_zone_name=<host zone name in route53>
```

### Initialize terraform

```.sh
cd ./terraform
terraform init
```

### Create or change app server and netowrk

```.sh
cd ./terraform
terraform apply
```

### Deploy and Start application on EC2

```.sh
ansible-playbook -i ./ansible/production.aws_ec2.yml ./ansible/roles/webservers/tasks/main.yml
```

### Destroy app server and netowrk

```.sh
cd ./terraform
terraform destroy
```
