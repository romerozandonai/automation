# author: Bruno Romero Costa Zandonai
# version: 0.1.2
# date: 23/02/2024
# description: stop RDS instances, passed as parameter (from parameter store, or other source)
# use case: import script on AWS Lambda, and put in AWS EventBridge a rule do execute/schedule the Lambda call
# impacted services: RDS, Lambda, EventBridge
# possible improvments: collect RDS instances identifiers using boto3 RDS client

import boto3

REGION = 'AWS_REGION'
AWS_ACCESS_KEY = "AWS_ACCESS_KEY_HERE"
AWS_SECRET_KEY = "AWS_SECRET_KEY_HERE"

identifier = 'DB_INSTANCE_IDENTIFIER'
rds = boto3.client('rds', 
    region_name=REGION,
    aws_access_key_id = AWS_ACCESS_KEY,
    aws_secret_access_key = AWS_ACCESS_KEY
)

def lambda_handler(event, context):
    rds.stop_db_instance(DBInstanceIdentifier=identifier)