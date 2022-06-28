resource "aws_eks_cluster" "EKSCluster" {
    name = "mf-cluster"
    role_arn = "arn:aws:iam::686014939614:role/mf-cluster-role"
    version = "1.22"
    vpc_config {
        security_group_ids = [
            "sg-0832de8fd085fbc5a"
        ]
        subnet_ids = [
            "subnet-03f764dd4f39eb8a0",
            "subnet-0387226499b546a79",
            "subnet-0622239ec5b360273"
        ]
    }
}