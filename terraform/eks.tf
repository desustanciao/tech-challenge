module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "21.15.1"

  name                = var.cluster_name
  kubernetes_version  = "1.33"

  vpc_id     = aws_vpc.k8s_vpc.id
  subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }
  
  endpoint_public_access = true


  eks_managed_node_groups = {
    default = {
      desired_size = var.node_desired_capacity
      max_size     = 3
      min_size     = 1

      instance_types = [var.node_instance_type]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  
  access_entries = {
    github_actions = {
      principal_arn = "arn:aws:iam::${var.account_id}:user/${var.eks_user}"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}
