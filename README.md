# AWS Resources with Terraform, Jenkins ci-cd, and Hosting a static website in s3

![Screenshot 2024-04-01 153801](https://github.com/Eric-Kay/petstore_DevSecOps/assets/126447235/dd6a318a-486d-4c41-a497-af0248a31de5)

In today’s fast-paced world of cloud computing, the ability to rapidly and efficiently provision infrastructure is a game-changer. This is where Infrastructure as Code (IaC) comes into play, allowing us to define and manage our infrastructure in a code-based manner. In this blog post, we will explore how to harness the power of IaC by using two essential tools: Terraform and Jenkins, in conjunction with Amazon Web Services (AWS).

Terraform is an open-source IaC tool that enables us to define, create, and manage our infrastructure using declarative configuration files. Jenkins, on the other hand, is a widely adopted automation server that helps streamline the software development and deployment process.

Our journey will encompass several key objectives:
1. __Setting up Terraform and Jenkins:__  We’ll start by ensuring you have all the prerequisites in place, including an AWS account, Terraform, Jenkins, and Docker. We’ll walk you through the installation and configuration of these essential tools.
2. __Creating the Terraform Scripts:__  We’ll delve into the heart of IaC by crafting Terraform scripts to provision AWS resources. Along the way, we’ll introduce the concept of user data, a powerful feature that allows us to automate tasks like launching containers within our instances.
3. __Running Two Application Containers with User Data:__ To demonstrate the practical application of user data, we’ll guide you through launching not just one but two application containers within your AWS instances. This step showcases the versatility and automation capabilities of IaC.
4. __DevOps project we will be using Terraform and AWS Cloud:__  to set up static website hosting fully automated in seconds. This Terraform project will help beginners understand the concept and working of Terraform with AWS and how you can create a one-click automated solution using Terraform in DevOps
5. ## __Setting up Infrastructure State Management:__
   + __S3 Bucket for Terraform State:__  We’ll create an AWS S3 bucket dedicated to securely storing your Terraform state files. This is essential for maintaining the state of your infrastructure in a central location.
   + __DynamoDB Table for Locking:__ In addition to the S3 bucket, we’ll set up an AWS DynamoDB table to enable locking capabilities. This ensures that your infrastructure remains in a consistent state when multiple users are working concurrently.
6. __Integrating Jenkins and Terraform:__ To tie it all together, we’ll demonstrate how to integrate Jenkins with Terraform. This integration will empower you to automate the provisioning process, enhance the efficiency of your infrastructure management, and ensure that your Terraform state is securely stored and locked when needed.

# Prerequisites:
Before you embark on the journey of provisioning AWS resources using Terraform and Jenkins, it’s crucial to ensure that you have all the necessary components and configurations in place. Here are the prerequisites you should have before starting this tutorial:
1. __AWS Account:__ You must have an active AWS account with administrative privileges or the necessary permissions to create and manage AWS resources.
2. __S3 Bucket for Terraform State:__
   + Purpose: To securely store your Terraform state files remotely.
   + Log in to your AWS Management Console.
   + Navigate to the S3 service.
   + Create an S3 bucket with a unique name in the desired AWS region.
   + Note down the bucket name as you’ll use it in your Terraform scripts.
3. __DynamoDB Table for Locking Capability:__
   + Access the AWS Management Console.
   + Go to the DynamoDB service.
   + Create a DynamoDB table with a unique name and primary key.
   + Configure the table’s read and write capacity settings as needed.
   + Note down the table name for reference.
4. __Jenkins Setup:__
   + Ensure that Jenkins is up and running in your environment.
   + Configure Jenkins with the necessary plugins for AWS and Terraform integration.
5. __Terraform Installation in Jenkins:__
   + Terraform should be installed on the Jenkins server to execute Terraform scripts as part of your CI/CD pipeline.
6. __Terraform Files in Source Code Management (SCM):__
   + Your Terraform configuration files should already be available in your Source Code Management system (e.g., Git). Make sure you have the necessary access rights to the repository.
7. __IAM Role for Jenkins EC2 Instance:__
   + Create an IAM role in AWS.
   + Attach the appropriate policy that grants permissions for AWS resource provisioning, DynamoDB access, S3 bucket operations, and any other required permissions.
   + Associate the IAM role with the Jenkins EC2 instance.
8. __GitHub Repository (Optional):__
   + If you’re using a public repository as an example, you can fork the repository and start making changes in your own forked repository. Ensure that you have the necessary access to the repository.
  
## __STEP1:__ Create an Ubuntu(22.04) T2 Large Instance
Launch an AWS T2 Large Instance. Use the image as Ubuntu. You can create a new key pair or use an existing one. Enable HTTP and HTTPS settings in the Security Group and open all ports (not best case to open all ports but just for learning purposes it’s okay).

![Screenshot 2024-03-31 225000](https://github.com/Eric-Kay/petstore_DevSecOps/assets/126447235/7c51f123-bdc1-4ad8-ab88-57e236b85356)

## __STEP2:__  Install Jenkins, Docker and Trivy

2A — To Install Jenkins
2A — To Install Jenkins

Connect to your console, and enter these commands to Install Jenkins
```bash
vi jenkins.sh #make sure run in Root (or) add at userdata while ec2 launch
```
```bash
#!/bin/bash
sudo apt update -y
#sudo apt upgrade -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install temurin-17-jdk -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                              /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl status jenkins
```
```bash
sudo chmod 777 jenkins.sh
./jenkins.sh    # this will installl jenkins
```

Once Jenkins is installed, you will need to go to your AWS EC2 Security Group and open Inbound Port 8080 and 8090, 9000 for sonar, since Jenkins works on Port 8080.

But for this Application case, we are running Jenkins on another port. so change the port to 8090 using the below commands.

```bash
sudo systemctl stop jenkins
sudo systemctl status jenkins
cd /etc/default
sudo vi jenkins   #chnage port HTTP_PORT=8090 and save and exit
cd /lib/systemd/system
sudo vi jenkins.service  #change Environments="Jenkins_port=8090" save and exit
sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo systemctl status jenkins

```

Now, grab your Public IP Address
```bash
<EC2 Public IP Address:8080>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

![Screenshot 2024-03-18 232236](https://github.com/Eric-Kay/netflix-clone-on-kubernetes/assets/126447235/37441fee-47da-43b3-8591-0c86eb096624)

Unlock Jenkins using an administrative password and install the suggested plugins.

2B — Install Docker

```bash
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER   #my case is ubuntu
newgrp docker
sudo chmod 777 /var/run/docker.sock
```
After the docker installation, we create a sonarqube container (Remember to add 9000 ports in the security group).
```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
![Screenshot 2024-03-18 233551](https://github.com/Eric-Kay/netflix-clone-on-kubernetes/assets/126447235/e0f4ec44-8e4e-44b0-a22b-6fd7e841ce3b)

Enter username and password, click on login and change password

```bash
username admin
password admin
```
2C — Install Trivy

```bash
vi trivy.sh
```

```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

```
Next, we will log in to Jenkins and start to configure our Pipeline in Jenkins.

## Install Plugins like JDK, Sonarqube Scanner,Terraform

Goto Manage Jenkins →Plugins → Available Plugins →

Install below plugins

1 → Eclipse Temurin Installer (Install without restart)

2 → SonarQube Scanner (Install without restart)

3 → Terraform

Install Terraform on our Jenkins machine

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

check terraform version
```bash
terraform --version
```
let’s find the path to our terraform (we will use it in the tools section of Terraform).
```bash
which terraform
```

## Configure Java and Terraform in Global Tool Configuration
+ Goto Manage Jenkins → Tools → Install JDK(17) → Click on Apply and save.

## Configure Sonar Server in Manage Jenkins
Grab the Public IP Address of your EC2 Instance, Sonarqube works on Port 9000, so <Public IP>:9000. Goto your Sonarqube Server. Click on Administration → Security → Users → Click on Tokens and Update Token → Give it a name → and click on Generate Token

+ Goto Jenkins Dashboard → Manage Jenkins → Credentials → Add Secret Text.
+ Now, go to Dashboard → Manage Jenkins → System and configure system.
+ Goto Administration–> Configuration–>Webhooks and insert the jenkins URL.

![Screenshot 2024-04-01 141650](https://github.com/Eric-Kay/petstore_DevSecOps/assets/126447235/2dee5554-a686-45f4-8520-70ceebb68bc6)

Add details.

```bash
#in url section of quality gate
<http://jenkins-public-ip:8090>/sonarqube-webhook/
```
## Create an IAM, S3 bucket and Dynamo DB table.
+ Navigate to __AWS CONSOLE__ → click on search field → click roles → click create roles → click AWS services → click choose a service or use case → click on Ec2.
+ Add the following policies:
   + AmazonEC2FullAccess
   + AmazonS3FullAccess
   + AmazonDynamoDBFullAccess
+ Go to the Jenkins instance and add this role to the Ec2 instance.
+ Search for S3 in console and Click “Create bucket”
+ Search for DynamoDB in console and Click “Create table”
+ Click the “Table name” field. enter “dynamodb_table = “name of your choice””
+ Click the “Enter the partition key name” field and type LockID

##  Docker plugin and credential Setup

We need to install the Docker tool in our system, Goto Dashboard → Manage Plugins → Available plugins → Search for Docker and install these plugins

Docker

Docker Commons

Docker Pipeline

Docker API

docker-build-step

and click on install without restart.

+ Now, goto Dashboard → Manage Jenkins → Tools → Add DockerHub Username and Password under Global Credentials.
