# Koko Devops

Sample devops project demonstrating setting up infrustuture automatically, CI/CD pipelines and a minimal flask app hosted on AWS.

## Technology Stack

- [Flask](https://flask.palletsprojects.com/en/2.1.x/)
- [Terraform](https://www.terraform.io/)
- [Jenkins](https://www.jenkins.io/)
- [Ansible](https://www.ansible.com/)
- [AWS](https://aws.amazon.com/)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)

## Getting Started
Download the source code of this project from Github
```bash
git clone git@github.com:EduhG/koko-devops.git
```
or

```bash
git clone https://github.com/EduhG/koko-devops.git
```

### Prerequisites
To get started you need to have terraform installed locally. You can install it quicky by following this tutorial. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

Acess to an AWS account. Create an IAM user with access to ecr and ec2


### Configuration

## Setup

### Configure Infrastructure
First lets create the neccessary resources required to run the application. We will be using terrafor to do this.


Create an ssh access key. This is optional as you can use the default access key. Remember not to overwrite your current one located in `~/.ssh/id_rsa`
```bash
ssh-keygen -t rsa -b 4096
```

Create a terraform.tfvars file and file with the following details.

``` bash
touch devops/infra/terraform.tfvars
```
```bash
public_key_path       = "LOCATION_OF_PUBLIC_SSH_KEY"
private_key_path      = "LOCATION_OF_PRIVATE_SSH_KEY"
aws_access_key_id     = "ACCESS_KEY_ID_CREATED_ABOVE"
aws_secret_access_key = "SECRET_ACCESS_KEY_CREATED_ABOVE"
cicd_instance_type    = "t3a.small"
master_instance_type  = "t3a.medium"
```

Create the required resources. Use a helper command from the Makefile
```bash
make apply
```
This will create two EC2 servers along with required security groups.
    
`CI/CD Server` - Will run all our ci/cd pipelines here. It is configured using jenkins and ansible.

`Kubernetes Master Node` - This will run our kubernetes cluster

Once the infrusture has been created, we will now configure `jenkins`. To do this, first, ssh into the ci/cd server
```bash
make ssh-cicd
```
Copy the jenkins master password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
If the location above is unavaiable give it a few more minutes.

### Configure Jenkins
Open your brouser and visit the following url `http://CICD_SERVER_IP:8080`. On this page paste the jenkins master password we copied from the last step. Complete the initial jenkins setup of creating an admin user and installing the suggested plugins.

After installing, the suggested plugins, we will install 3 more plugins that will be used to run our CI/CD pipeline. In your jenkins instance go to `Manage plugins` and install the following plugins `CloudBees AWS Credentials`, `Amazon ECR`, `Docker Pipeline`. You can search for these plugins in the Available tab. After they're installed, they appear in the Installed tab.

Next we need to configure some credentials that jenkins will use to run our pipelines. In your Jenkins instance, go to <b>Manage Jenkins</b>, then <b>Manage Credentials</b>, then <b>Jenkins Store</b>, then <b>Global Credentials (unrestricted)</b>, and finally <b>Add Credentials</b>.
Fill in the following fields, leaving everything else as default:

* Kind - AWS credentials
* ID - koko-devops-aws-credentials
* Access Key ID - Access Key ID from earlier
* Secret Access Key - Secret Access Key from earlier

Click OK to save.

### Update Jenkinsfile
Next update jenkinsfile if you used a different ID when creating AWS Credentials change `koko-devops-aws-credentials` in the jenkinsfile to the one you created.

Update the docker registry url also to match the one that was created when you ran terraform init, you can get it from the outputs section.

Next push this to <b>your github repo</b>.

### Create Jenkins Pipeline
Create a jenkins multibranch pipeline. Navigate to <b>Dashboard</b> then <b>Create Item</b>, Enter your prefered name, then choose <b>Multibranch Pipeline</b>. Finally click OK.

Next fill in the form. Display Name can be same name as the github-repo name.

Next under `Branch Sources` select github, then add the url to your github repository for this project.

Next configure `Behaviors`. Leave the defaults, then add `Filter by name (with wildcards)`. In the include field add `main feature/*`. This will make the pipeline run whenever there are changes to the two branches; `main` and `feature/*`.

Next add `Check out to matching local branch`, `Clean before checkout` and `Clean after checkout`

Finally click Save.

This will scan the github repository configuring pipelines for the two branches we specified.

The `main` branch build will configure, install kubenetes cluster and finally launch our application within the cluster.

### Automatically trigger pipeline

Finally to automatically trigger the build pipeline when an update happens on the github repository, configure github credentials.

Firt creat a `Personal Access Token` in github.

Next navigate <b>Manage Credentials</b> in your jenkins instance then create another credential. This time choose `Kind` to be `Username/Password`. Under username enter your github username, for password enter the generated `Personal Access Token`

Once this has been created, navigate to the created build pipeline, and update the github credentials under `Branch Sources`.

The build should automatically trigger once more and every other time a change happens on github.


### Configure Master Node
Since we are using a single instance for our kubernetes cluster we need to configure kubernetes to allow pod deployment on the master node.

SSH into the master node
```bash
make ssh-master
```

Once logged in update kubernetes using
```
kubectl taint node --all node-role.kubernetes.io/control-plane-

kubectl taint node --all node-role.kubernetes.io/master-
```

After a few minutes we should be able to access the deployed app in the browser with this url `http://MASTER_SERVER_IP:30007`


### Tearing down resources
The deployed application and all its resources can be destroyed using terraform with the following command
```
terraform destroy
```