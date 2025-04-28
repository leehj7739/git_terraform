# OpenStack 인증 정보
variable "username" {
  description = "카카오 클라우드 사용자 이름"
  type        = string
}

variable "password" {
  description = "카카오 클라우드 비밀번호"
  type        = string
  sensitive   = true
}

variable "tenant_name" {
  description = "카카오 클라우드 프로젝트 이름"
  type        = string
}

variable "region" {
  description = "리소스를 생성할 리전"
  type        = string
  default     = "kr-central-2"
}

# 네트워크 설정
variable "network_name" {
  description = "네트워크 이름"
  type        = string
}

# 인스턴스 설정
variable "create_instance" {
  description = "인스턴스 생성 여부"
  type        = bool
  default     = false
}

variable "image_name" {
  description = "인스턴스의 이미지 이름"
  type        = string
  default     = "Ubuntu 22.04"
}

variable "image_id" {
  description = "인스턴스의 이미지 ID"
  type        = string
}

variable "flavor_name" {
  description = "인스턴스 타입(flavor)"
  type        = string
  default     = "t1.small"
}

variable "key_name" {
  description = "SSH 접속을 위한 키 페어 이름"
  type        = string
}

variable "root_volume_size" {
  description = "루트 볼륨 크기(GB)"
  type        = number
  default     = 20
}

# 추가 볼륨 관련 변수
variable "create_data_volume" {
  description = "추가 데이터 볼륨 생성 여부"
  type        = bool
  default     = false
}

variable "data_volume_size" {
  description = "데이터 볼륨 크기(GB)"
  type        = number
  default     = 50
}

# 오브젝트 스토리지 관련 변수
variable "create_s3_bucket" {
  description = "오브젝트 스토리지 컨테이너 생성 여부"
  type        = bool
  default     = false
}

variable "s3_bucket_suffix" {
  description = "오브젝트 스토리지 컨테이너 이름 접미사"
  type        = string
  default     = "unique-suffix"
}

# 환경 설정
variable "environment" {
  description = "Environment name (blue/green)"
  type        = string
}

variable "security_group_name" {
  description = "보안 그룹 이름"
  type        = string
}

variable "app_repository" {
  description = "애플리케이션 저장소 URL"
  type        = string
}

variable "floating_ip_pool" {
  description = "Floating IP pool name"
  type        = string
} 