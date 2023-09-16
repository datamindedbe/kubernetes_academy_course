terraform {
  backend "s3" {
    bucket         = "kubernetes-academy-terraform-state"
    region         = "eu-west-1"
    encrypt        = "true"
    key            = "cluster-setup.tfstate"
    dynamodb_table = "terraform-training-lock-30"
  }
}
