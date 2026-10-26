resource "aws_iam_role" "cluster_role" {
  name = "project-${var.env_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "eks.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "eks" {
  name = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version = var.kubernetes_version

  vpc_config {
    subnet_ids = [
        aws_subnet.private_
    ]
    endpoint_public_access = true
  }
  depends_on = [ 
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
   ]
}

resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement =[{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "nodes" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "main-node-group"
  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = var.private_subnet_ids

  capacity_type = "ON_DEMAND"
  instance_types = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_desired_size
    max_size = var.node_max_size
    min_size = var.node_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
