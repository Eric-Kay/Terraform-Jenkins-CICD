terraform {
  backend "s3" {
    bucket         = "eric-devops-jenkins"
    key            = "my-terraform-environment/main"
    region         = "ap-south-1"
    dynamodb_table = "eric-devops-jenkins-dynamo-db"
  }
}
