# AWS Resources with Terraform, Jenkins ci-cd, and Hosting a static website in s3

![Screenshot 2024-04-01 153801](https://github.com/Eric-Kay/petstore_DevSecOps/assets/126447235/dd6a318a-486d-4c41-a497-af0248a31de5)

In today’s fast-paced world of cloud computing, the ability to rapidly and efficiently provision infrastructure is a game-changer. This is where Infrastructure as Code (IaC) comes into play, allowing us to define and manage our infrastructure in a code-based manner. In this blog post, we will explore how to harness the power of IaC by using two essential tools: Terraform and Jenkins, in conjunction with Amazon Web Services (AWS).

Terraform is an open-source IaC tool that enables us to define, create, and manage our infrastructure using declarative configuration files. Jenkins, on the other hand, is a widely adopted automation server that helps streamline the software development and deployment process.

Our journey will encompass several key objectives:

Setting up Terraform and Jenkins: We’ll start by ensuring you have all the prerequisites in place, including an AWS account, Terraform, Jenkins, and Docker. We’ll walk you through the installation and configuration of these essential tools.
Creating the Terraform Scripts: We’ll delve into the heart of IaC by crafting Terraform scripts to provision AWS resources. Along the way, we’ll introduce the concept of user data, a powerful feature that allows us to automate tasks like launching containers within our instances.
Running Two Application Containers with User Data: To demonstrate the practical application of user data, we’ll guide you through launching not just one but two application containers within your AWS instances. This step showcases the versatility and automation capabilities of IaC.
DevOps project we will be using Terraform and AWS Cloud to set up static website hosting fully automated in seconds. This Terraform project will help beginners understand the concept and working of Terraform with AWS and how you can create a one-click automated solution using Terraform in DevOps
Setting up Infrastructure State Management:
S3 Bucket for Terraform State: We’ll create an AWS S3 bucket dedicated to securely storing your Terraform state files. This is essential for maintaining the state of your infrastructure in a central location.
DynamoDB Table for Locking: In addition to the S3 bucket, we’ll set up an AWS DynamoDB table to enable locking capabilities. This ensures that your infrastructure remains in a consistent state when multiple users are working concurrently.
Integrating Jenkins and Terraform: To tie it all together, we’ll demonstrate how to integrate Jenkins with Terraform. This integration will empower you to automate the provisioning process, enhance the efficiency of your infrastructure management, and ensure that your Terraform state is securely stored and locked when needed.
Prerequisites:
Before you embark on the journey of provisioning AWS resources using Terraform and Jenkins, it’s crucial to ensure that you have all the necessary components and configurations in place. Here are the prerequisites you should have before starting this tutorial:

AWS Account: You must have an active AWS account with administrative privileges or the necessary permissions to create and manage AWS resources.
S3 Bucket for Terraform State:
Purpose: To securely store your Terraform state files remotely.
Steps:
Log in to your AWS Management Console.
Navigate to the S3 service.
Create an S3 bucket with a unique name in the desired AWS region.
Note down the bucket name as you’ll use it in your Terraform scripts.
DynamoDB Table for Locking Capability:
Purpose: To enable locking for Terraform state management.
Steps:
Access the AWS Management Console.
Go to the DynamoDB service.
Create a DynamoDB table with a unique name and primary key.
Configure the table’s read and write capacity settings as needed.
Note down the table name for reference.
Jenkins Setup:
Ensure that Jenkins is up and running in your environment.
Configure Jenkins with the necessary plugins for AWS and Terraform integration.
Terraform Installation in Jenkins:
Terraform should be installed on the Jenkins server to execute Terraform scripts as part of your CI/CD pipeline.
Terraform Files in Source Code Management (SCM):
Your Terraform configuration files should already be available in your Source Code Management system (e.g., Git). Make sure you have the necessary access rights to the repository.
IAM Role for Jenkins EC2 Instance:
Purpose: To grant the Jenkins EC2 instance the necessary permissions to interact with AWS resources.
Steps:
Create an IAM role in AWS.
Attach the appropriate policy that grants permissions for AWS resource provisioning, DynamoDB access, S3 bucket operations, and any other required permissions.
Associate the IAM role with the Jenkins EC2 instance.
GitHub Repository (Optional):
If you’re using a public repository as an example, you can fork the repository and start making changes in your own forked repository. Ensure that you have the necessary access to the repository.
With these prerequisites in place, you’ll be well-prepared to dive into the tutorial and learn how to leverage Terraform, Jenkins, AWS S3, and DynamoDB to automate the provisioning and state management of your AWS resources. These foundational components are key to a successful IaC implementation and CI/CD pipeline for infrastructure.

Launch an Ubuntu(22.04) T2 Large Instance
Launch an AWS T2 Large Instance. Use the image as Ubuntu. You can create a new key pair or use an existing one. Enable HTTP and HTTPS settings in the Security Group and open all ports (not best case to open all ports but just for learning purposes it’s okay).
