# go-grpc-sample

## Build

```.sh
make build-example
```

## Start server

```.sh
./build/example_server
```

## Execute client request

```.sh
# When you request to EC2 server, you need to modify constant "address" in ./cmd/example_client/main.go and rebuild
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

### Set environment variables for terraform parameters

```.sh
export TF_VAR_webapp_1a_key_name=<your key pair name to connect EC2 instance>
export TF_VAR_webapp_1a_ssh_public_key=$(cat ./.ssh/<your public key name>
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

### Start server on EC2

```.sh
# upload your app binary
scp -i ./.ssh/<your private key name> -r ./build ec2-user@<host>:~/build
# login host and run app server
ssh -i ./.ssh/<your private key name> ec2-user@<host>
./build/example_server
```

### Destroy app server and netowrk

```.sh
cd ./terraform
terraform destroy
```
