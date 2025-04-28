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
  description = "보안 그룹 이름"
  type        = string
}

variable "network_name" {
  description = "네트워크 이름"
  type        = string
  default     = "75ec8f1b-f756-45ec-b84d-6124b2bd2f2b_7c90b71b-e11a-48dc-83a0-e2bf7394bfb4"
}

variable "floating_ip_pool" {
  description = "Floating IP pool name"
  type        = string
}

variable "app_repository" {
  description = "애플리케이션 저장소 URL"
  type        = string
} 