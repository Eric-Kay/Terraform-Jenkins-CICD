terraform {
  backend "s3" {
    bucket         = "eric-devops-jenkins"
    key            = "my-terraform-environment/main"
    region         = "eu-west-2"
    dynamodb_table = "eric-devops-jenkins-dynamo-db"
  }
}
