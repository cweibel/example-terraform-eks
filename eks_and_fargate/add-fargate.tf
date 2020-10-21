resource "aws_iam_role" "iam_role_fargate" {
  name = "eks-fargate-profile-example"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "example-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.iam_role_fargate.name
}
resource "aws_eks_fargate_profile" "aws_eks_fargate_profile1" {

  depends_on = [module.eks]

  cluster_name           = local.cluster_name
  fargate_profile_name   = "fg_profile_default_namespace"
  pod_execution_role_arn = aws_iam_role.iam_role_fargate.arn
  subnet_ids             = module.vpc.aws_subnet_private_prod_ids
  selector {
    namespace = "default"
  }
}

