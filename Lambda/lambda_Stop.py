import boto3
region = 'us-west-2'
instances = ['i-05fd9af471d656818', 'i-0ec2572d224f67d62']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
