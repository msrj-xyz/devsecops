# Input Variables for DevSecOps Infrastructure

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devsecops-portfolio"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project_name))
    error_message = "Project name must contain only alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = "DevSecOps Team"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the cluster"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  
  validation {
    condition = alltrue([
      for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "All CIDR blocks must be valid IPv4 CIDR blocks."
  }
}

# Kubernetes Configuration
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
  
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "Kubernetes version must be in format X.Y (e.g., 1.28)."
  }
}

# Node Group Configuration
variable "node_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium", "t3.large"]
  
  validation {
    condition = alltrue([
      for instance_type in var.node_instance_types : 
      can(regex("^[a-z0-9]+\\.[a-z0-9]+$", instance_type))
    ])
    error_message = "Instance types must be valid AWS instance type identifiers."
  }
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
  
  validation {
    condition     = var.node_group_min_size >= 1 && var.node_group_min_size <= 100
    error_message = "Node group minimum size must be between 1 and 100."
  }
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 10
  
  validation {
    condition     = var.node_group_max_size >= 1 && var.node_group_max_size <= 100
    error_message = "Node group maximum size must be between 1 and 100."
  }
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 3
  
  validation {
    condition     = var.node_group_desired_size >= 1 && var.node_group_desired_size <= 100
    error_message = "Node group desired size must be between 1 and 100."
  }
}

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name for SSH access to nodes"
  type        = string
  default     = null
}

# Security Configuration
variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts"
  type        = bool
  default     = true
}

variable "enable_cluster_encryption" {
  description = "Enable cluster encryption at rest"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = false
}

# Monitoring and Logging
variable "enable_cluster_logging" {
  description = "Enable EKS control plane logging"
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "List of control plane log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  validation {
    condition = alltrue([
      for log_type in var.cluster_log_types :
      contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], log_type)
    ])
    error_message = "Log types must be one of: api, audit, authenticator, controllerManager, scheduler."
  }
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
  
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch Logs retention period."
  }
}

# Backup and State Management
variable "terraform_state_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "devsecops-terraform-state"
}

variable "terraform_lock_table" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
  default     = "devsecops-terraform-locks"
}

# Compliance and Governance
variable "compliance_framework" {
  description = "Compliance framework to apply (SOC2, HIPAA, PCI-DSS)"
  type        = string
  default     = "SOC2"
  
  validation {
    condition     = contains(["SOC2", "HIPAA", "PCI-DSS", "GDPR", "NONE"], var.compliance_framework)
    error_message = "Compliance framework must be one of: SOC2, HIPAA, PCI-DSS, GDPR, NONE."
  }
}

variable "data_classification" {
  description = "Data classification level (public, internal, confidential, restricted)"
  type        = string
  default     = "internal"
  
  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.data_classification)
    error_message = "Data classification must be one of: public, internal, confidential, restricted."
  }
}

# Cost Optimization
variable "enable_spot_instances" {
  description = "Enable spot instances for cost optimization"
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "Maximum price for spot instances"
  type        = string
  default     = "0.1"
  
  validation {
    condition     = can(tonumber(var.spot_max_price)) && tonumber(var.spot_max_price) > 0
    error_message = "Spot max price must be a valid positive number."
  }
}

# Disaster Recovery
variable "enable_multi_az" {
  description = "Enable multi-AZ deployment for high availability"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
  
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "Backup retention days must be between 1 and 365."
  }
}

# Security Tools Integration
variable "enable_falco" {
  description = "Enable Falco runtime security monitoring"
  type        = bool
  default     = true
}

variable "enable_open_policy_agent" {
  description = "Enable Open Policy Agent for policy enforcement"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Enable cert-manager for certificate management"
  type        = bool
  default     = true
}

variable "enable_external_secrets" {
  description = "Enable External Secrets Operator"
  type        = bool
  default     = true
}

# Notification Settings
variable "slack_webhook_url" {
  description = "Slack webhook URL for notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "email_notifications" {
  description = "List of email addresses for notifications"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for email in var.email_notifications :
      can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All email addresses must be valid email format."
  }
}

# Development and Testing
variable "enable_development_tools" {
  description = "Enable development and debugging tools"
  type        = bool
  default     = false
}

variable "enable_testing_namespace" {
  description = "Create dedicated namespace for testing"
  type        = bool
  default     = true
}

# Performance and Scaling
variable "enable_horizontal_pod_autoscaler" {
  description = "Enable Horizontal Pod Autoscaler"
  type        = bool
  default     = true
}

variable "enable_vertical_pod_autoscaler" {
  description = "Enable Vertical Pod Autoscaler"
  type        = bool
  default     = true
}

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster Autoscaler"
  type        = bool
  default     = true
}

# Custom Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
  
  validation {
    condition = alltrue([
      for key in keys(var.additional_tags) :
      can(regex("^[a-zA-Z0-9:/_.-]+$", key)) && length(key) <= 128
    ])
    error_message = "Tag keys must be valid AWS tag key format and not exceed 128 characters."
  }
  
  validation {
    condition = alltrue([
      for value in values(var.additional_tags) :
      length(value) <= 256
    ])
    error_message = "Tag values must not exceed 256 characters."
  }
}