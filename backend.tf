terraform {
  backend "s3" {
    bucket         = "jenkins-mama"
    key            = "my-terraform-environment/main"
    region         = "us-east-1"
    dynamodb_table = "eric-devops-jenkins-dynamo-db"
  }
}
