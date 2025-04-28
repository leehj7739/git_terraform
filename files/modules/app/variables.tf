variable "environment" {
  description = "Environment name (blue/green)"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "image_id" {
  description = "Image ID for the instance"
  type        = string
}

variable "flavor_name" {
  description = "Flavor name for the instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "network_name" {
  description = "Network name"
  type        = string
}

variable "floating_ip_pool" {
  description = "Floating IP pool name"
  type        = string
}

variable "app_repository" {
  description = "Git repository URL for the FastAPI application"
  type        = string
} 