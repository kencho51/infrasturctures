#!/usr/bin/env bash

if [ -f .init_env_vars ];then
  source .init_env_vars
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
    --ssh-key)
        has_ssh_key=true
        aws_ssh_key=$2
        shift 2
        ;;
    --region)
        AWS_REGION=$2
        shift 2
        ;;
    --web-ec2-type)
        web_ec2_type=$2
        shift 2
        ;;
    --profile)
        profile=$2
        shift 2
        ;;
    *)
        echo "Invalid option: $1 in"
        echo $call_str
        exit 1
        ;;
    esac
done

if [ -z $aws_ssh_key ];then
  read -p "You need to specify the path to the ssh private key to use to connect to the EC2 instance: " aws_ssh_key
fi

if [ -z $AWS_REGION ];then
  read -p "You need to specify an AWS region: " AWS_REGION
fi

if [ -z $web_ec2_type ];then
  read -p "You need to specify an AWS ec2 instance type: " web_ec2_type
fi

if [ -z $profile ];then
  read -p "You need to specify an AWS profile: " profile
fi

echo ""
echo "Current directory: $(pwd)"
echo "Path to SSH key: $aws_ssh_key"
echo "Region: $AWS_REGION"
echo "Web EC2 Type: $web_ec2_type"
echo "AWS profile: $profile"
echo ""

read -p "Do you want to continue (y/n)?" choice
case "$choice" in
  y|Y )
    echo "yes"
    ;;
  n|N )
    echo "no"
    exit 0
    ;;
  * )
    echo "Invalid choice"
    exit 1
    ;;
esac

key_name=$(echo $aws_ssh_key | rev | cut -d"/" -f 1 | rev | cut -d"." -f 1)

echo "key_name = \"$key_name\"" > terraform.tfvars
echo "aws_region = \"$AWS_REGION\"" >> terraform.tfvars
echo "web_ec2_type = \"$web_ec2_type\"" >> terraform.tfvars
echo "profile = \"$profile\"" >> terraform.tfvars

cp ../../terraform.tf .
cp ../../input.tf .
cp ../../setup_server.sh .

terraform init