terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
  required_version = "1.12.2"
}

locals {
  kubeconfig = "~/.kube/config"
}

provider "kubernetes" {
  config_path    = local.kubeconfig
  config_context = "minikube"
}

provider "helm" {
  kubernetes = {
    config_path = local.kubeconfig
  }
}
