region = "us-east-1"
profile = "gd-aws" // profile name when running aws configure
vpc_cidr    = "10.0.0.0/16"
cidrs = {
  public  = "10.0.0.0/24"
  private = "10.0.1.0/24"
}
ec2_instance_type       = "t3.micro"
ec2_ami                 = "ami-0e2ff28bfb72a4e45"
ec2_public_key_path     = "~/.ssh/keypair-gd-aws.pub" // path for your key on your local machine
ec2_key_name            = "keypair-gd-aws"
