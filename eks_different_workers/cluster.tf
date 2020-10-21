locals {
  cluster_name = "my-eks-cluster"
  cluster_version = "1.18"
}

module "vpc" {
  source = "git::ssh://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"

  aws_region = "us-west-2"
  az_count   = 3
  aws_azs    = "us-west-2a, us-west-2b, us-west-2c"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.2.0"
  cluster_name = local.cluster_name
  cluster_version = local.cluster_version
  vpc_id       = module.vpc.aws_vpc_id
  subnets      = module.vpc.aws_subnet_private_prod_ids

  tags = {
    cluster_tag = "my-eks-cluster-tag"
  }

## aka unmanaged workers:
  worker_groups = [
    {
      name = "my-worker-group-1"
      instance_type = "t2.small"
      asg_max_size  = 2
    }
  ]


  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_type = "t2.small"
      tags = {
        tag1 = "mytag"
      }
      additional_tags = {
        ExtraTag = "example"
      }
    }
  }
  manage_aws_auth = false
}

