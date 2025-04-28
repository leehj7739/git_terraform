variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "module-vm"
}

variable "create_instance" {
  description = "인스턴스 생성 여부"
  type        = bool
  default     = false
}

variable "image_id" {
  description = "인스턴스의 이미지 ID"
  type        = string
  default     = ""
}

variable "flavor_name" {
  description = "인스턴스 타입(flavor)"
  type        = string
}

variable "key_name" {
  description = "SSH 접속을 위한 키 페어 이름"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "보안 그룹 목록"
  type        = list(string)
}

variable "network_name" {
  description = "네트워크 이름"
  type        = string
  default     = "75ec8f1b-f756-45ec-b84d-6124b2bd2f2b_7c90b71b-e11a-48dc-83a0-e2bf7394bfb4"

}

variable "root_volume_size" {
  description = "루트 볼륨 크기(GB)"
  type        = number
  default     = 20
}
