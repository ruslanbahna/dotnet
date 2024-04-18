# dotnet
The sponge command is part of the moreutils package and provides a useful utility for editing files in place. It allows you to modify a file using input from a pipeline and then write the changes back to the same file. This is particularly handy in situations where the output of a command needs to overwrite the content of a file.

In the context of the jq command, using sponge helps avoid potential issues related to redirecting the output directly to the input file. It helps ensure that the changes are written back to the file only after the jq command has completed, preventing potential race conditions or data corruption.

dotnet-core vulnerabilities: When using both the mcr.microsoft.com/dotnet/sdk:8.0-jammy base image and the Ubuntu base image with .NET SDK 8.0 installed, Trivy is scanning for vulnerabilities specific to the dotnet-core environment. This includes the core .NET SDK components and related dependencies.

nuget vulnerabilities: This is specific to the Microsoft container (mcr.microsoft.com/dotnet/sdk:8.0-jammy). NuGet is a package manager for .NET, and Trivy is scanning for vulnerabilities within the NuGet packages or libraries that might be included in this image.

The reason Trivy is detecting both dotnet-core and nuget vulnerabilities in the Microsoft container, but only dotnet-core vulnerabilities in the Ubuntu container with .NET SDK installed, is likely due to the different compositions of these images. The Microsoft container is specifically optimized for .NET development and thus includes additional components (like NuGet packages) that are directly relevant to .NET, whereas the Ubuntu image with .NET SDK installed is more generic and might not include all the specific .NET-related tools and libraries found in the Microsoft container.

Dockerfile explanation
FROM ubuntu:latest: Starts with the latest Ubuntu base image.

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm: Sets environment variables to avoid interactive prompts during the build and sets a terminal type.

RUN ... apt-get update: Updates the package lists for Ubuntu.

... apt-get ... upgrade: Upgrades all the installed packages to their latest versions.

... apt-get ... install -y wget apt-transport-https software-properties-common: Installs necessary packages like wget (for downloading files), apt-transport-https (for downloading over HTTPS), and software-properties-common (for managing software repositories).

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb ...: Downloads the Microsoft package repository configuration.

dpkg -i packages-microsoft-prod.deb: Installs the downloaded package.

rm packages-microsoft-prod.deb: Removes the .deb file after installation to save space.

apt-get update: Updates the package lists again, this time including Microsoft's repository.

apt-get ... install --yes dotnet-sdk-8.0 jq moreutils nuget: Installs the .NET SDK, along with some additional utilities (jq, moreutils, nuget).

jq 'del(.libraries["System.Drawing.Common/4.7.0"])' ... | sponge ...: Modifies a JSON file within the .NET SDK, removing a specific entry. This step seems specific to your setup.

apt-get purge --yes wget apt-transport-https software-properties-common jq moreutils: Removes packages that were only needed for setup to reduce image size.

apt --yes autoremove: Automatically removes any unused packages.

apt-get clean; rm -rf /var/lib/apt/lists/*: Cleans up the package cache and temporary files to reduce the image size.
The --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt part of the RUN command in your Dockerfile is a Docker BuildKit feature. It mounts a cache for /var/cache/apt and /var/lib/apt directories during the build process. This cache helps to speed up the build by reusing the previously downloaded packages and apt indexes. It's particularly useful for iterative development and building images, as it prevents the need to re-download packages each time the image is built, thereby reducing build times.


The Docker build logs you've shared confirm that Node.js and npm were successfully installed in the image using NVM. However, you're encountering issues when trying to use npm inside a running container. This problem often arises due to the way NVM initializes Node.js and npm environments, which is designed for interactive shell sessions.

When you use docker exec to run a command inside a container, it doesn't necessarily invoke the full shell initialization process (e.g., sourcing .bashrc or .profile), which is where NVM typically gets initialized. As a result, the Node.js and npm installed by NVM may not be available in the PATH for non-interactive commands executed with docker exec.

Solution
To ensure that NVM and the installed Node.js and npm versions are properly initialized when running commands via docker exec, you need to explicitly source the NVM scripts as part of your command. This ensures that the necessary environment variables and PATH adjustments made by NVM are applied.

Adjust your docker exec command to explicitly source NVM:

bash
Copy code
docker exec my-running-image /bin/bash -c '. $NVM_DIR/nvm.sh && npm --version'
Here, . $NVM_DIR/nvm.sh sources the NVM script to initialize the NVM environment, making node and npm available for use.

Explanation
. $NVM_DIR/nvm.sh: The dot (.) is a shorthand for the source command in bash, which executes the script in the current session. $NVM_DIR is an environment variable pointing to the directory where NVM is installed, which you've set in your Dockerfile.

npm --version: This part of the command simply runs npm to output its version, verifying that npm is accessible.

By including the NVM sourcing in your command, you ensure that NVM and the Node.js environment it manages are initialized for that command, even in a non-interactive shell session started by docker exec.

```bash
#!/bin/bash

# Load NVM
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Execute the command passed to the docker run command
exec "$@"


FROM ubuntu:latest

# Install dependencies and NVM in a single RUN command to reduce layers, and cleanup in the same layer
RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    rm -rf /var/lib/apt/lists/*

# Environment variable for NVM
ENV NVM_DIR /root/.nvm

# Install Node.js LTS and NPM, and cleanup in the same layer to keep the image size small
RUN . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm use --lts && \
    nvm cache clear && \
    rm -rf /var/lib/apt/lists/*

# Add NVM, Node.js, and npm binaries to PATH
ENV PATH $NVM_DIR/versions/node/$(nvm version --lts)/bin:$PATH

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]

    - name: test
      env:
        DOCKER_CONTENT_TRUST: 0
      run: |
        docker run --name my-running-image -dt ${{ secrets.DOCKERHUB_USERNAME }}/node:v4
        docker inspect my-running-image
        docker exec my-running-image /bin/bash -c '. $NVM_DIR/nvm.sh && npm --version'
```

GPG public brew 32F7D37FA5DDECF4603219925039B284BDD0DE39

1. Welcome and Introduction (5 minutes)
Brief welcome and overview of the meeting’s objectives.
Quick round of introductions if necessary.
2. Overview of the Task (10 minutes)
Present the task: Implementing Wiz scanning for container images as part of the CI/CD pipeline using GitHub Actions.
Discuss the importance of scanning container images for CVEs before they are published.
Highlight the goal of limiting manual steps to ensure efficiency and reliability.
3. Understanding Wiz Scanning (15 minutes)
Brief explanation of Wiz, its capabilities, and why it's chosen for this task.
Discuss the specific aspects of container images that Wiz will scan for and the expected output.
4. Comparison with Trivy Scans (15 minutes)
Overview of Trivy and its current use in the workflow.
Discuss criteria for comparing Wiz and Trivy scans (e.g., comprehensiveness, speed, ease of use).
5. GitHub Actions Implementation (20 minutes)
Discuss the steps required to integrate Wiz scanning into GitHub Actions.
Setting up the Wiz scanner as part of the CI/CD pipeline.
Configuring GitHub Actions to trigger Wiz scanning on specific events.
Explore potential challenges and solutions in the integration process.
6. Coordination and Roles (10 minutes)
Assign responsibilities among the team members.
Who will be responsible for setting up the Wiz integration?
Who will handle the comparison with Trivy scans?
Discuss how to coordinate efforts and communicate progress.
7. Next Steps and Timeline (10 minutes)
Outline immediate next steps following the meeting.
Set tentative deadlines for key milestones in the project.
Agree on a schedule for regular updates or follow-up meetings.
8. Open Discussion (10 minutes)
Open the floor for any questions, concerns, or suggestions from the participants.
9. Wrap-Up and Closing (5 minutes)
Summarize the key points discussed and decisions made.
Confirm the action items and responsible individuals.
Thank everyone for their participation and adjourn the meeting.

Subject: Decision on the Proposed Role Transition Options

This Docker image is built on Ubuntu 22.04 LTS, ensuring a stable and secure operating system layer. It features the OpenJDK 21.0.2 Temurin distribution, which is a Long-Term Support (LTS) version of the Java Runtime Environment. This JRE provides extensive compatibility and support for Java applications, reflecting the latest standards and advancements in Java technology. The image also includes Apache Tomcat 10.1.20, a robust web server and servlet container that supports Servlet 5.0, JSP 3.0, and EL 4.0 specifications, aligning with Jakarta EE 9 standards. This makes the image highly suitable for deploying modern Java web applications.

Hi, As you can see from my resume I am a DevOps Engineer with over 4 Years experience in IT field.
 I am Working at AT&T. Mostly I am specialized in using cloud Devops Technology, and currently Ia am working  with Kubernetes and Terraform, as a  CI/CD tool mostly of the time I am using GitHub Actions, but in the past Ive also used Jenkins. 
Just A little bit of How I started  my IT journey back on 2018. I started as a Cloud Engineer where I designed, provision, and maintain cloud based systems, I learned more about K8s and releasing application, so  
This is how it get me going with Devops Engineer Role. Right now with my current role, I am a part of Devops Infrastructure team, pretty much were we implanting and maintaining new clusters into existing ecosystem. Working with Developers day-to day to make sure the applications are up and running, creating and maintaining the pipelines whenever is necessary, depending on the applications that we are deploying, 
Also I worked in Implementing some monitoring solutions like Prometheus and Grafana, I mostly focusing on GCP, specially on GKE clusters. Use a lot of terraform (Infrastructure as Code), to spin up the resources whenever is needed, mostly we work on python and some nodeJS  applications support the  multiple environments.
Beside that I also would like to say mention that currently I have like 8 certifications. CKA and CKAD, Solution architect, cloud practitioner and sysops administrator, also HashiCorp terraform and vault associate, And also azure fundamental. Want also to add that I Enjoy learning new staff and new technology that can be implemented in my day to day duties and tasks. This is pretty mush all about myself
 DevOPs is the bridge between development and operation, focusing on automating processes, improving collaboration, and ensuring seamless software delivery.
   •	Build, instal, configure and troubleshoot multiple environments
	•	Contribute to architectural design
Contributing to architectural design in Kubernetes involves designing the overall structure and organization of the applications and services running on the cluster. Here are some key aspects to consider when contributing to the architectural design:
		Microservices vs. Monoliths: where we have to decide whether to use a microservices architecture or a monolithic approach. Microservices promote loosely coupled, independent services, while monoliths bundle all functionalities into a single application. Each approach has its advantages and challenges, so  we have to decide based on our needs and requirements the one that aligns best with organization's goals and development team's ability to execute the task.
		Service Discovery: we have to plan how services will discover and communicate with each other. Kubernetes provides a built-in service discovery mechanism through DNS, but we can also explore other options like service meshes (e.g., Istio) or API gateways.
		Scalability: we have to consider how the given  architecture will handle scaling. Kubernetes supports horizontal and vertical scaling, so we should define how  applications will scale based on demand.
		Fault Tolerance: help us to design  applications to be fault-tolerant. Kubernetes can help by automatically restarting failed containers, but we should also plan for application-level redundancy and resilience.
		#Storage and Data Management: Determine how your applications will handle data storage. Kubernetes offers Persistent Volumes (PVs) and Persistent Volume Claims (PVCs) for long-term data storage.
		Resource Management:  where we have  to Define resource requests and limits for our applications to ensure fair resource allocation within the cluster.
		Pod Affinity and Anti-Affinity:  we usually Use pod affinity and anti-affinity rules to control how pods are scheduled and distributed across nodes in the cluster. This can help optimize performance and resource utilization.
		Multi-tenancy: If our cluster is hosting applications from multiple teams or users, we can design a multi-tenant architecture that isolates resources and provides appropriate access controls.
		Security and Network Policies: Ensures that the architecture incorporates proper security measures. Implementing network policies and RBAC to control access between services and protect sensitive data.
		External Services and Ingress: Planing how our applications will interact with external services and users. Use can use Ingress controllers to expose services to the outside world securely.
		Observability and Monitoring: Design your architecture to be observable. Implement logging, monitoring, and tracing solutions to understand the behavior of your applications and diagnose issues.
		Deployment Strategies: Decide on deployment strategies, such as rolling updates, blue-green deployments, or canary deployments, to manage changes to your applications without service interruptions.
		Configuration Management: Determine how your applications will handle configuration changes. Kubernetes provides ConfigMaps and Secrets to manage configuration data separately from the application code.
		Backup and Disaster Recovery: Create a plan for backing up critical data and ensure you have a disaster recovery strategy in place.

	•	Build and maintain CICD pipelines
	•	Monitor system performance and availability
	•	Deploy code and secure enviorments for several applications
		Set Up Kubernetes Cluster: First, you need to have a Kubernetes cluster up and running. There are various ways to do this, such as using managed Kubernetes services like Google Kubernetes Engine (GKE), Amazon Elastic Kubernetes Service (EKS), or self-managing with tools like Minikube, kubeadm, or kops.
		Create Kubernetes Manifests: Kubernetes uses YAML manifests to define and deploy resources. You'll need to create manifests for each application you want to deploy. These manifests typically include Deployment or StatefulSet, Service, and possibly ConfigMap or Secret objects.
		Create Docker Images: Containerize your applications by creating Docker images. A Docker image contains the application code and dependencies needed to run your application. Store these images in a container registry like Docker Hub or Google Container Registry (GCR).
		Create Kubernetes Secrets: If your applications require sensitive information like API keys, passwords, or certificates, store them as Kubernetes Secrets. This ensures the data remains encrypted at rest and is only accessible to authorized applications.
		Deploy Applications: Use kubectl or Kubernetes Dashboard to deploy your applications using the manifests you created. For example:  Copy codekubectl apply -f your_app_deployment.yaml   
		Network Policies: Implement Network Policies to control network traffic between applications and secure communication within the cluster. Network Policies allow you to define ingress and egress rules for pods.
		RBAC (Role-Based Access Control): Set up Role-Based Access Control to define granular access permissions for users and services within the cluster. This helps ensure only authorized entities can interact with your cluster.
		Use Kubernetes Secrets and ConfigMaps: Instead of hardcoding sensitive information in your application code, retrieve them from Kubernetes Secrets or ConfigMaps. This way, you can update sensitive data without redeploying the entire application.

		Update and Patch Regularly: Keep your Kubernetes cluster, container images, and applications up-to-date with the latest security patches to minimize vulnerabilities.
		Monitor and Set Alerts: Implement monitoring solutions to observe the health and performance of your applications and the Kubernetes cluster. Set up alerts to notify you about any unusual behavior or potential security incidents.
	•	Support K8s cluster.

Logging an Monitoring in cloud
Google Cloud Platform (GCP):
		Stackdriver Logging (formerly known as Cloud Logging): Stackdriver Logging allows us to view, search, and analyze logs generated by various GCP services and custom applications. It supports logs from Compute Engine, Kubernetes Engine, Cloud Functions, Cloud Storage, and more.
		Stackdriver Monitoring (formerly known as Cloud Monitoring): Stackdriver Monitoring provides monitoring and alerting capabilities to track the performance of our resources and services.
		Cloud Audit Logs: GCP's Cloud Audit Logs capture administrative activity and actions performed on resources within our GCP projects. It tracks changes made through the GCP Console, APIs, and other management tools.

Amazon Web Services (AWS):
		AWS CloudTrail: AWS CloudTrail records API activity and events for AWS services. It provides an audit trail of actions taken by users, services, or AWS resources. CloudTrail logs can be stored in an S3 bucket or forwarded to CloudWatch Logs.
		Amazon CloudWatch Logs: CloudWatch Logs enables us to monitor, store, and access log files from AWS resources and custom applications. It can be used to centralize logs from various AWS services and EC2 instances.
		AWS Config: AWS Config tracks changes to your AWS resources and records configuration details over time. It provides a historical view of resource configurations and helps to keep resource compliance against desired configurations.
		AWS CloudTrail Insights: This feature in AWS CloudTrail provides an additional layer of threat detection by automatically analyzing CloudTrail events for unusual activity patterns and potential security risks.

 I would lie to talk about a project. Where we had to migrate from ec2 instances to kubernetes solution, from AWS to GCP, So implementing an planing took a little bit longer for us, because we had to plan in advance how the application and the data is gonna be migrated. And we had to think about the final cutdown date, when we gonna be fully switching over. Process itself was pretty simple, getting approval and implementing took a little bit of time. So we have ec2 instance and we have rds instance. So on the GKE side we had to implement vpc, and on top of VPC we supposed to create kubernetes cluster.
On top of kubernetes cluster we had to deploy application with the helm charts. And this helm chart part had to be automated. The question comes in when we gonna migrate the data. So moving the application from one cloud provider to another cloud provider, I have also think about moving the database. So what we did we implemented the application with a dummy database we copied from AWS account, and the we had the application up and running. And the we started using AWS DMS servise, wich stands for database migration service, to migrate the data from was to GCP on daily bases. We had everything automated, from building vpc  and gke and to application deployment. The only thing that was done manually is running DMS task.

Securityin related to kubernetes
		Security of Cloud (Cloud Infrastructure):
	•	where we Use strong authentication and access controls to manage user access to cloud resources.
	•	Regularly audit and monitor cloud resources for any unauthorized access or suspicious activities.
	•	Encrypt data at rest and in transit to protect sensitive information.
	•	Implement security groups and network ACLs to control traffic between cloud resources.
	•	Keep cloud infrastructure components, such as databases and server software, up-to-date with security patches.
		Security of Cluster (Kubernetes Cluster):
	•	Enable Role-Based Access Control (RBAC) to control access to Kubernetes resources.
	•	Configure Network Policies to restrict network communication between pods and namespaces.
	•	Regularly update Kubernetes components to the latest stable versions.
	•	Secure access to the Kubernetes API server using TLS.
		Security of Container (Container Images and Runtime):
	•	Only use trusted container images from reputable sources or build them from verified sources.
	•	Implement image scanning to detect and fix vulnerabilities in container images.
	•	Ensure containers run with non-root users whenever possible to reduce the potential impact of attacks.
		Security of Code (Application Security):
	•	we have to Follow secure coding practices to prevent common vulnerabilities
	•	conducting  code reviews and static code analysis to identify and fix security issues.
	•	Use libraries and frameworks with a good security track record, and keep them up-to-date with security patches.
	•	Enable strong authentication and authorization mechanisms in the application.
By addressing security concerns in each of these areas (cloud, cluster, container, and code), you can significantly improve the overall security posture of your applications and infrastructure.

Our role in the project is to release an application into kubernetes system
Steps:
Clone the repo
Build docker image
Push docker image to registry

Deploy docker image to DEV, QA, STAGE, PROD
To Hold Kubernetes cluster and all cloud related resources we have to provision a project with necessary, and services enabled we have to create bucket to hold our terraform state file.


Cluster common tools
Cluster autoscaller
Cluster authorization
Metrics server
For EKS vpc-cni
Cert manager issue certificates automatically to our application

External Dns to manages domain entries for a our application


Implementing HashiCorp Vault on a Kubernetes system to manage and centralize static and dynamic credentials involves several steps. Below is a high-level guide to help you get started:
		Prerequisites:
	•	Ensure you have a running Kubernetes cluster with sufficient resources.
	•	Have administrative access to the cluster to deploy and manage resources.
	•	Install the kubectl command-line tool to interact with your Kubernetes cluster.
		Deploy HashiCorp Vault:
	•	Create a Kubernetes namespace for Vault: kubectl create namespace vault.
	•	Deploy Vault using Helm or a custom Kubernetes manifest. Helm is recommended for simplicity and easy upgrades. To install Vault using Helm, run:csharp  Copy codehelm repo add hashicorp https://helm.releases.hashicorp.com helm install vault hashicorp/vault --namespace vault --values my-values.yaml   
		Configure Vault Storage:
	•	Choose a storage backend for Vault. For production environments, it's recommended to use a durable and highly available backend like Consul or an external cloud storage service.
	•	Configure Vault to use the chosen storage backend by updating the Vault server configuration.
		Initialize and Unseal Vault:
	•	After Vault is deployed, initialize the Vault cluster and retrieve the initial root token and unseal keys. Keep these keys safe as they are essential for Vault's operation.
	•	Unseal Vault using the unseal keys to make it accessible.
		Configure Authentication and Authorization:
	•	Define authentication methods for users and applications to access Vault. Kubernetes authentication is common in a Kubernetes environment, allowing Kubernetes Service Accounts or tokens to authenticate with Vault.
	•	Configure authorization policies to control what users and applications can access within Vault.
		Enable Secrets Engines:
	•	Enable and configure secrets engines in Vault to manage different types of credentials (e.g., databases, AWS, certificates).
	•	Use static secrets engines for managing fixed credentials and dynamic secrets engines for generating short-lived credentials on-demand.
		Use Kubernetes Secrets Integration:
	•	Configure the Kubernetes auth method in Vault to authenticate Kubernetes Service Accounts.
	•	Create policies that grant access to specific secrets engines and paths within Vault.
	•	Map Kubernetes Service Accounts to appropriate policies in Vault.
		Access Vault from Applications:
	•	Utilize Vault's API or official client libraries to interact with Vault from your applications.
	•	Retrieve dynamic credentials from Vault when needed and ensure that they are properly revoked after use.
		Implement Best Practices:
	•	Follow best practices for securely managing Vault, including secure storage of unseal keys and root tokens, regular backups, and disaster recovery planning.
	•	Consider implementing audit logging to track Vault usage and changes.
		Monitor and Maintain:
	•	Set up monitoring for Vault to ensure its availability and performance.
	•	Regularly update Vault to the latest version to benefit from security patches and new features.
	•	Perform periodic security audits to ensure compliance with security policies and industry standards.



 














Complex task
challenge to design and implement a CI/CD pipeline for a complex application with multiple microservices. The goal is to automate the build, test, and deployment process to ensure efficient and error-free software delivery.
Architectural Complexity
The application consists of several interconnected microservices, each with its own dependencies and configuration requirements. Understanding of the application architecture and designing a pipeline that accommodates the different services can be challenging.
Solution Approach: I would start by analyzing the existing application architecture, identifying the dependencies and communication patterns between the microservices. Then, I would break down the pipeline into stages, such as source code management, build, testing, and deployment. To address the complexity, I would leverage containerization technologies like Docker and orchestration tools like Kubernetes to manage the deployment and scaling of the microservices.
		control plane orMaster Components:
	•	API Server: Acts as the front-end for the Kubernetes control plane. It handles API requests, validates them, and performs actions on the cluster.
	•	etcd: A distributed key-value store that stores the configuration data of the cluster, ensuring data consistency and fault tolerance.
	•	Controller Manager: Runs various controllers responsible for managing different aspects of the cluster (e.g., node controller, replication controller).
	•	Scheduler: Assigns pods to nodes based on resource availability and scheduling constraints.
		worker Node Components:
	•	Kubelet: The primary agent that runs on each node and communicates with the API server. It ensures that containers are running as expected on the node.
	•	kube-proxy: Manages network routing for services within the cluster and performs connection forwarding.
		Add-ons:
	•	DNS Add-on: Provides DNS-based service discovery for pods.
	•	Ingress Controller: Manages external access to services within the cluster.
	•	Container Network Interface (CNI) plugin: Implements the networking model for pods.
		Persistent Storage:
	•	Storage Classes: Define different types of storage volumes that can be dynamically provisioned and attached to pods.
	•	Persistent Volumes (PV): Represents a physical storage volume provisioned in the cluster.
	•	Persistent Volume Claims (PVC): A request for a specific amount of persistent storage by a pod.


Account set up


ReadME


GKE MODULE




Customizable module that creates namespaces for python or nodes application
Proprierieties of name space
Quota how many objects (resources) can be created secrets, services, config maps, deployments, stateful sets, pods
Limit ranges
LImit per pod, per container, per Persistent volume claim.
Also customized permisions with necessary role role binding and service accounts 

Deploy Application in Kubernetes system using Terraform an Helm

Instead of using helm install we are using helm provider with teraform and manage all of your resources declarative way.
Terraform init terraform apply


CI?CD

env:
  repo:         "https://github.com/farrukh90/artemis.git"
  app_version:  "2.0.0"
  project_id:   "csubrsnzorjkvdca"
  repo_region:  "us-central1"
  app_name:     "artemis"



name: ContinuousDelivery
# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest


    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3


      # Runs a set of commands using the runners shell
      - name: Clone a repo
        run: |
          git clone ${{ env.repo }}


      # Runs a set of commands using the runners shell
      - name: Switch Branches
        working-directory: ${{ env.app_name }}
        run: |
          git checkout ${{ env.app_version }}
          ls -l



      # Runs a set of commands using the runners shell
      - name: Build Image
        working-directory: ${{ env.app_name }}
        run: |
          docker build -t ${{ env.app_name }}:${{ env.app_version }}   . 


      # Runs a set of commands using the runners shell
      - name: Tag Image
        working-directory: ${{ env.app_name }}
        run: |
          docker image tag ${{ env.app_name }}:${{ env.app_version }} ${{ env.repo_region }}-docker.pkg.dev/${{ env.project_id }}/${{ env.app_name }}/${{ env.app_name }}:${{ env.app_version }}     


      # Runs a single command using the runners shell
      - name: Run a one-line script
        run: gcloud version 



      - name: Authenticate to Google account
        run: |
          gcloud auth activate-service-account --key-file="service-account.json"
          gcloud config set project ${{ env.project_id }}



      - name: Authenticate to repository
        run: |
          gcloud auth configure-docker  ${{ env.repo_region }}-docker.pkg.dev

          


      # Runs a set of commands using the runners shell
      - name: Image push
        working-directory: ${{ env.app_name }}
        run: |
          docker push ${{ env.repo_region }}-docker.pkg.dev/${{ env.project_id }}/${{ env.app_name }}/${{ env.app_name }}:${{ env.app_version }}  
Prometheus:   is metrics collecting tool for multiple services. if you have EC2 instances or if you have kubernetes, docker you can have prometheus on the system and collect the information and shares with you. its visualizing and its telling me what is going on with my Kubernetes system. 

Grafana: With Grafana we can add some data into Grafana and visualize some data. We can get the information from Prometheus, MySQL, Cloud Watch, Jira.
 
	•	By default Prometheus and Grafana talks to itself right away. We don’t have to configure separately or add it as a data. We can define Prometheus in Grafana codes while we are deploying it. ( with URL )
	•	You can actually find out how much of a data being created, how many users exist on the system, how many transactions are being happening in the system. (for  MySQL)

Upgrading a GKE cluster
1. Check for updates
   Send out emails to inform
  Schedule SAT 6PM -10PM
2. Auto upgrade
		Backup: Before performing any upgrades, it's always recommended to create a backup or snapshot of your important data and configurations to avoid potential data loss.
		Review the release notes: Check the GKE release notes to understand the changes, new features, and any known issues or limitations associated with the target version you want to upgrade to. This helps you prepare for any specific considerations or changes required in your applications.
		Validate compatibility: Ensure that your applications and workloads are compatible with the target GKE version. Test your applications in a staging environment or conduct thorough compatibility checks to identify any potential issues or incompatibilities.
		Upgrade control plane: GKE allows you to upgrade the control plane independently of the node pools. Upgrading the control plane ensures you have the latest Kubernetes API version and features. You can upgrade the control plane using the following command: css  Copy codegcloud container clusters upgrade CLUSTER_NAME --master --cluster-version=TARGET_VERSION    Replace CLUSTER_NAME with the name of your GKE cluster, and TARGET_VERSION with the desired version to upgrade to.
		Upgrade node pools: After upgrading the control plane, you can proceed to upgrade the node pools. Node pools are groups of nodes in a cluster with the same configuration. You can upgrade node pools one by one or in parallel, depending on your requirements. To upgrade a node pool, you can use the following command: css  Copy codegcloud container clusters upgrade CLUSTER_NAME --node-pool POOL_NAME --cluster-version=TARGET_VERSION    Replace CLUSTER_NAME with your cluster's name, POOL_NAME with the node pool you want to upgrade, and TARGET_VERSION with the desired version.
		Verify upgrade: After the upgrade process, it's essential to verify that the cluster and applications are functioning as expected. Test your applications, perform functional checks, and monitor the cluster for any issues or errors.
It's important to note that upgrading a GKE cluster may incur downtime for your applications during the control plane upgrade process. To minimize disruption, you can consider strategies like using multiple node pools and a rolling upgrade approach for node pools.
Before performing any upgrades, ensure you have a clear understanding of the impact and have tested the upgrade process in a non-production environment.



Upgrading a EKS cluster
1. Check for updates
   Send out emails to inform
  Schedule SAT 6PM -10PM

2. Upgrade cluster from console
    Upgrade master node
   Upgrade worker nodes (manually)
     cordon all worker nodes (ex 9 nodes)
     scale from 9 to 18 with new AMI
     drain OLD nodes
     kubectl delete nodes
     Delta worker node from console
3. Send Email with read me file

Continuous build

  



Continuous deployment





Terraform nodule
