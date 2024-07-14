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
. Install `awscli`
. Create Access Key in IAM User (katpri). 
. `configure aws`
. Login: 
```
➜  travelperk-assessment git:(main) ✗ aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 303981612052.dkr.ecr.eu-north-1.amazonaws.com

Login Succeeded
```
. Create ECR Repository:
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
. Build the Docker Image: 
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
. Create ECS Cluster:
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
. Create VPC
. Create Subnet