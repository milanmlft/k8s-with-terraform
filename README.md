# Deploying Kubernetes with Terraform

This repo defines the configuration for a toy deployment of a [Kubernetes](https://kubernetes.io/) cluster using
[minikube](https://minikube.sigs.k8s.io/docs/) and [terraform](https://developer.hashicorp.com/terraform/).

The deployment consists of two pods containing a simple [nginx](https://nginx.org/en/) server.

## Requirements

- Install [minikube](https://minikube.sigs.k8s.io/docs/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- Install [terraform](https://developer.hashicorp.com/terraform/install)

## Set up

Start the `minikube` cluster:

```shell
minikube start
```

Initialise and apply the Terraform configuration:

```shell
terraform init
terraform apply
```

## Resources

- [Deploy Kubernetes Dashboard with Metrics Server using Terraform and Helm on Docker Desktop - DEV Community](https://dev.to/garis_space/terraform-and-helm-to-deploy-the-kubernetes-dashboard-1dpl)
- [Deploy Kubernetes Resources in Minikube cluster using Terraform - DEV Community](https://dev.to/chefgs/deploy-kubernetes-resources-in-minikube-cluster-using-terraform-1p8o)


