terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
  required_version = "1.5.7"
}

locals {
  kubeconfig = "~/.kube/config"
}

provider "kubernetes" {
  config_path    = local.kubeconfig
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig
  }

}
