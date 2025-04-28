terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
  }
}

provider "openstack" {
  auth_url    = "https://iam.kakaocloud.com/identity/v3"
  region      = var.region
  user_name   = var.username
  password    = var.password
  tenant_name = var.tenant_name
  domain_name = var.domain_name
}

# Ubuntu 이미지 찾기
data "openstack_images_image_v2" "ubuntu" {
  name        = var.image_name
  most_recent = true
}

# 네트워크 보안 그룹 생성
resource "openstack_networking_secgroup_v2" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
}

# 보안 그룹 이름 충돌 방지를 위한 랜덤 접미사
resource "random_id" "sg_suffix" {
  byte_length = 4
}

# SSH 규칙
resource "openstack_networking_secgroup_rule_v2" "web_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.id
}

# HTTP 규칙
resource "openstack_networking_secgroup_rule_v2" "web_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.id
}

# 인스턴스 생성
resource "openstack_compute_instance_v2" "web" {
  count           = var.create_instance ? 1 : 0
  name            = "${var.dev_name}-web-server"
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_name
  security_groups = [openstack_networking_secgroup_v2.web.name]

  network {
    name = var.network_name
  }
  
  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    volume_size           = var.root_volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
}

# EBS 볼륨 생성 (선택적)
resource "openstack_blockstorage_volume_v3" "data" {
  count = var.create_data_volume ? 1 : 0

  name        = "${var.dev_name}-data-volume"
  size        = var.data_volume_size
  volume_type = "gp2"
}

# EBS 볼륨 연결 (선택적)
resource "openstack_compute_volume_attach_v2" "data_attach" {
  count = var.create_instance && var.create_data_volume ? 1 : 0

  instance_id = openstack_compute_instance_v2.web[0].id
  volume_id   = openstack_blockstorage_volume_v3.data[0].id
}

# S3 버킷 생성 (선택적)
resource "openstack_objectstorage_container_v1" "storage" {
  count = var.create_s3_bucket ? 1 : 0

  name = "${var.dev_name}-storage-${var.s3_bucket_suffix}"
}

# 라우터 생성
resource "openstack_networking_router_v2" "router" {
  name                = "${var.project_name}-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

# 서브넷 생성
resource "openstack_networking_subnet_v2" "subnet" {
  name            = "${var.project_name}-subnet"
  network_id      = var.network_id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# 라우터 인터페이스 연결
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# 포트 생성 및 인스턴스 연결
resource "openstack_networking_port_v2" "instance_port" {
  count = var.create_instance ? 1 : 0

  name           = "${var.dev_name}-instance-port"
  network_id     = var.network_id
  admin_state_up = true

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }

  security_group_ids = [openstack_networking_secgroup_v2.web.id]
}

# 인스턴스에 포트 연결
resource "openstack_compute_interface_attach_v2" "instance_interface" {
  count = var.create_instance ? 1 : 0

  instance_id = openstack_compute_instance_v2.web[0].id
  port_id     = openstack_networking_port_v2.instance_port[0].id
}

# 앱 서버 모듈 호출
module "app_server" {
  source = "./modules/app"

  project_name      = var.project_name
  environment       = var.environment
  instance_count    = var.instance_count
  image_id          = var.image_id
  flavor_name       = var.flavor_name
  key_name          = var.key_name
  network_id        = var.network_id
  subnet_id         = openstack_networking_subnet_v2.subnet.id
  security_group_id = openstack_networking_secgroup_v2.web.id
  app_repository    = var.app_repository
}