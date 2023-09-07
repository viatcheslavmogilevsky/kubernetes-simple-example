# Simple kubernetes example

Simple example of EKS cluster and k8s deployment

### Folder structure
* `kubernetes-manifest` - Contains kubernets manifest of multicontainer deployment
* `terraform-modules` - contains local terraform modules which used in `terraform-root-module`
* `terraform-root-module` - main terraform directory


## Prerequisites

* terraform
* aws-cli
* access to AWS account with s3 state bucket and dynamodb table



### How to run
To initialize and run terraform, please run: 

```bash
 # export AWS_PROFILE=exampla-aws-account
 pushd ./terraform-root-module
 terraform init  --backend-config=backend.tfvars
 terraform apply
 popd
 # deploy kuberntes manifest:
 pushd ./kubernetes-manifest
 aws eks --region us-east-1  update-kubeconfig --name test --kubeconfig=kubeconfigs/test.yaml
 kubectl apply -f deployment.yaml --kubeconfig kubeconfigs/test.yaml
 # check pods:
 kubectl get pod --kubeconfig kubeconfigs/test.yaml
 popd
```
