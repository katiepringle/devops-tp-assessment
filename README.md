# TravelPerk devops assessment 

Steps Taken:
1. Create Repo and copy existing one from TravelPerk.
2. Set Require status checks to pass before merging on `main` branch in Repository Branch Settings.
3. Create Dockerfile.
4. Install setuptools:
```
➜  ~ pip install setuptools

DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Requirement already satisfied: setuptools in /usr/local/lib/python3.7/site-packages (46.0.0)
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
```
```
➜  devops-tp-assessment git:(main) python3 setup.py install

Traceback (most recent call last):
  File "/Users/katie.pringle/github/devops-tp-assessment/setup.py", line 1, in <module>
    from setuptools import find_packages, setup
ModuleNotFoundError: No module named 'setuptools'
```
6.  Install `awscli`
7. Create Access Key in IAM User (katpri). 
8. `configure aws`
9. Login: 
```
➜  travelperk-assessment git:(main) ✗ aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 303981612052.dkr.ecr.eu-north-1.amazonaws.com

Login Succeeded
```
9. Create ECR Repository:
Now you can create the ECR repository:
```
aws ecr create-repository --repository-name hello-repo
```
Output:
```
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:eu-north-1:303981612052:repository/hello-repo",
        "registryId": "303981612052",
        "repositoryName": "hello-repo",
        "repositoryUri": "303981612052.dkr.ecr.eu-north-1.amazonaws.com/hello-repo",
        "createdAt": "2024-07-13T14:18:38.292000+01:00",
        "imageTagMutability": "MUTABLE",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        }
    }
}
```
10. Build the Docker Image: 
```
➜  travelperk-assessment git:(main) docker build -t hello-app .

[+] Building 13.9s (10/10) FINISHED                                             docker:desktop-linux
 => [internal] load build definition from Dockerfile                                            0.0s
 => => transferring dockerfile: 808B                                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.8-slim                              0.7s
 => [internal] load .dockerignore                                                               0.0s
 => => transferring context: 2B                                                                 0.0s
 => [1/5] FROM docker.io/library/python:3.8-slim@sha256:463e5f5018b45cc2621ec7308df9ecaaf87dea  0.0s
 => [internal] load build context                                                               0.1s
 => => transferring context: 9.75kB                                                             0.0s
 => CACHED [2/5] WORKDIR /app                                                                   0.0s
 => [3/5] COPY . .                                                                              0.1s
 => [4/5] RUN pip install --no-cache-dir -e .                                                  11.0s
 => [5/5] RUN python3 setup.py install                                                          1.4s
 => exporting to image                                                                          0.4s
 => => exporting layers                                                                         0.4s
 => => writing image sha256:a4a000a9e42834a76cd1a39706d5f6c562242177c9d1aa0b1331bb39d0223793    0.0s
 => => naming to docker.io/library/hello-app                                                    0.0s

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
  ```
  . Tag and push Docker image to ECR:
  ```
  ➜  travelperk-assessment git:(main) docker tag hello-app:latest 303981612052.dkr.ecr.us-east-1.amazonaws.com/hello-app:latest
docker push 303981612052.dkr.ecr.us-east-1.amazonaws.com/hello-app:latest

The push refers to repository [303981612052.dkr.ecr.us-east-1.amazonaws.com/hello-app]
ae6ec9ab1726: Preparing
af64f5e48a4a: Preparing
2f1bab7f7680: Preparing
6f75c507ceb2: Preparing
8b81fa4c988f: Preparing
38d395ab1f6c: Waiting
fda4aa6f33af: Waiting
a696d13c7344: Waiting
32148f9f6c5a: Waiting
no basic auth credentials
```
11. Create ECS Cluster:
```
➜  travelperk-assessment git:(main) aws ecs create-cluster --cluster-name hello-cluster
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:eu-north-1:303981612052:cluster/hello-cluster",
        "clusterName": "hello-cluster",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```

12. Create VPC
13. Create Subnets
14. Create terraform file for AWS resources (IaC) - `main.tf`, `variables.tf` and `data.tf`.
15. Create ECS task definition.
16. Create CI-CD yaml - Github Actions.
17. Explore Atlantis for CI/CD workflows with Terraform: 
```
➜  github git clone git@github.com:argoproj/argo-cd.git
Cloning into 'argo-cd'...
Enter passphrase for key '/Users/katie.pringle/.ssh/id_rsa':
remote: Enumerating objects: 131455, done.
remote: Counting objects: 100% (17708/17708), done.
remote: Compressing objects: 100% (614/614), done.
remote: Total 131455 (delta 17413), reused 17158 (delta 17092), pack-reused 113747
Receiving objects: 100% (131455/131455), 97.45 MiB | 5.64 MiB/s, done.
Resolving deltas: 100% (87041/87041), done.
Updating files: 100% (3616/3616), done.
➜  github cd argo-cd
➜  argo-cd git:(master) kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable
customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/applicationsets.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io created
➜  argo-cd git:(master) kubectl create namespace atlantis

namespace/atlantis created
➜  argo-cd git:(master) kubectl create secret generic atlantis-github-token \
  --from-literal=token=YOUR_GITHUB_TOKEN \
  -n atlantis

secret/atlantis-github-token created
➜  argo-cd git:(master) helm repo add atlantis https://runatlantis.github.io/helm-charts
helm repo update

helm install atlantis atlantis/atlantis \
  --namespace atlantis \
  --set github.token=$GITHUB_TOKEN \
  --set atlantis.secret=$GITHUB_SECRET

"atlantis" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "atlantis" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "grafana" chart repository
Update Complete. ⎈Happy Helming!⎈
```

References:
https://spacelift.io/blog/terraform-aws-vpc
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition 
https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html

