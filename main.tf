provider "aws" {
  region = "us-east-2"
  profile = "ManojChintaluri"
}

resource "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"

}

resource "aws_subnet" "subnet_az1" {
  availability_zone = "us-east-2a"
  cidr_block        = "172.31.4.0/24"
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet_az2" {
  availability_zone = "us-east-2b"
  cidr_block        = "172.31.5.0/24"
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet_az3" {
  availability_zone = "us-east-2c"
  cidr_block        = "172.31.6.0/24"
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_security_group" "aws_sg" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_msk_cluster" "msk1" {
  cluster_name           = "msk1"
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 10
    client_subnets = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
      aws_subnet.subnet_az3.id,
    ]
    security_groups = [aws_security_group.aws_sg.id]

  }
}
