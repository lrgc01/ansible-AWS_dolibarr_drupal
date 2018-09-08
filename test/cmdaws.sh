#!/bin/sh

#ssh -i ~/compucorp/compucorp-key.pem ubuntu@35.178.192.170
# root = T3st0nl!
# ubuntu = Nopasswd#3

CLIENTNAME="compucorp"

aws ec2 create-security-group --group-name ${CLIENTNAME}-sg --vpc-id vpc-032db86b --description "Sec. Group. for ${CLIENTNAME} hosts" 
aws ec2 authorize-security-group-ingress --group-id sg-03c91f91d3c54064e --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-03c91f91d3c54064e --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-03c91f91d3c54064e --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 run-instances --count 1 --image-id ami-6b3fd60c --key-name ${CLIENTNAME}-key --instance-type t2.micro --security-group-ids sg-03c91f91d3c54064e --subnet-id subnet-4736a92e --query 'Instances[0].InstanceId'
aws ec2 describe-instances --instance-ids i-0e5037342b8df59f3 --query 'Reservations[0].Instances[0].PublicDnsName'
aws ec2 describe-instances --instance-ids i-0e5037342b8df59f3 --query 'Reservations[0].Instances[0].PublicIPAddress'
