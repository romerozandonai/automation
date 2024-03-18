# author: Bruno Romero Costa Zandonai
# version: 0.1.2
# date: 23/02/2024
# description: start EC2 instances, passed as parameter (from parameter store, or other source)
# use case: import script on AWS Lambda, and put in AWS EventBridge a rule do execute/schedule the Lambda call
# impacted services: EC2, Lambda, EventBridge
# possible improvments: collect EC2 instances identifiers using boto3 EC2 client

import boto3

# main variables
REGION = 'AWS_REGION'
AWS_ACCESS_KEY = "AWS_ACCESS_KEY_HERE"
AWS_SECRET_KEY = "AWS_SECRET_KEY_HERE"

ec2_client = boto3.client('ec2', 
    region_name=REGION,
    aws_access_key_id = AWS_ACCESS_KEY,
    aws_secret_access_key = AWS_ACCESS_KEY
)
ssm_client = boto3.client('ssm', 
    region_name=REGION,
    aws_access_key_id = AWS_ACCESS_KEY,
    aws_secret_access_key = AWS_ACCESS_KEY
)


def lambda_handler(event, context):
    instances = get_parameters("/infra/ec2_instances") # dict/array
    ec2_client.start_instances(instances)


def get_parameters(parameter):
    parameter = ssm_client.get_parameter(Name=parameter, WithDecryption=True)
    return parameter ['Parameter']['Value']