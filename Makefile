.PHONY: help start-minikube stop-minikube status init plan apply destroy clean dashboard port-forward deploy

# Default target
.DEFAULT_GOAL := help

# Variables
TERRAFORM_DIR := deploy
NAMESPACE := k8s-ns-by-tf
DASHBOARD_PORT := 8080

deploy: start-minikube apply ## Complete setup: start minikube and deploy everything
	@echo "Deployment complete!"
	@echo "You can now access the dashboard with: make dashboard"
	@echo "Or check your pods with: make pods"

clean: destroy stop-minikube ## Clean up everything (destroy resources and stop minikube)
	@echo "Cleaning up Terraform files..."
	cd $(TERRAFORM_DIR) && rm -rf .terraform terraform.tfstate terraform.tfstate.backup

start-minikube: ## Start minikube cluster
	@echo "Starting minikube cluster..."
	minikube start
	@echo "Minikube cluster started successfully!"

stop-minikube: ## Stop minikube cluster
	@echo "Stopping minikube cluster..."
	minikube stop
	@echo "Minikube cluster stopped!"

status: ## Check minikube and kubectl status
	@echo "Checking minikube status..."
	minikube status
	@echo "\nChecking kubectl context..."
	kubectl config current-context
	@echo "\nChecking nodes..."
	kubectl get nodes

init: ## Initialize Terraform
	@echo "Initializing Terraform..."
	cd $(TERRAFORM_DIR) && terraform init
	@echo "Terraform initialized successfully!"

plan: init ## Show Terraform execution plan
	@echo "Running Terraform plan..."
	cd $(TERRAFORM_DIR) && terraform plan

apply: init ## Apply Terraform configuration
	@echo "Applying Terraform configuration..."
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve
	@echo "Terraform configuration applied successfully!"

destroy: init ## Destroy Terraform resources
	@echo "Destroying Terraform resources..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	@echo "Resources destroyed successfully!"

dashboard: ## Access Kubernetes Dashboard (requires deployment to be running)
	@echo "Opening Kubernetes Dashboard..."
	@echo "Dashboard will be available at: http://localhost:$(DASHBOARD_PORT)"
	kubectl port-forward -n $(NAMESPACE) service/kubernetes-dashboard-kong-proxy $(DASHBOARD_PORT):443

logs: ## Show logs from the nginx pods
	@echo "Showing logs from nginx pods..."
	kubectl logs -n $(NAMESPACE) -l test=MyExampleApp --tail=50

pods: ## List all pods in the namespace
	@echo "Listing pods in namespace $(NAMESPACE)..."
	kubectl get pods -n $(NAMESPACE)

services: ## List all services in the namespace
	@echo "Listing services in namespace $(NAMESPACE)..."
	kubectl get services -n $(NAMESPACE)

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
