##s3 bucket
your_aws_region = "ap-south-2"
# your_aws_s3_bucket = "ninjacart-jars"

### Network details
name = "my-vpc"
vpc_cidr_block = "10.0.0.0/16"
azs             = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
enable_vpn_gateway = false
Env = "test"

