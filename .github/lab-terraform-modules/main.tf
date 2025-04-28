terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.49.0"
    }
  }
}

provider "openstack" {
  auth_url    = "https://iam.kakaocloud.com/identity/v3"
  region      = var.region
  user_name   = var.username
  password    = var.password
  tenant_name = var.tenant_name
  domain_name = "kc-kdt-sfacspace2025"
}

# 인스턴스 설정
locals {
  image_id = "6f8f7e1c-b801-46c6-940c-603ffc05247a"
}

# 네트워크 보안 그룹 생성
resource "openstack_networking_secgroup_v2" "web" {
  name        = "${var.dev_name}-web-sg"
  description = "Security group for web servers"
}

# SSH 규칙
resource "openstack_networking_secgroup_rule_v2" "web_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.name
}

# HTTP 규칙
resource "openstack_networking_secgroup_rule_v2" "web_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.name
}

module "web_server" {
  source = "./modules/compute"

  create_instance   = var.create_instance
  count            = var.web_server_count
  instance_name    = "${var.dev_name}-web-server-${count.index + 1}"
  image_id         = local.image_id
  flavor_name      = var.flavor_name
  key_name         = var.key_name
  security_groups  = [openstack_networking_secgroup_v2.web.name]
  network_name     = "75ec8f1b-f756-45ec-b84d-6124b2bd2f2b_7c90b71b-e11a-48dc-83a0-e2bf7394bfb4"
  root_volume_size = var.root_volume_size
  user_data        = <<-EOF
    #cloud-config
    write_files:
      - path: /root/app/fastapi_app.py
        content: ${file("${path.module}/fastapi_app.py")}

      - path: /root/app/main.py
        content: |
          from fastapi_app import app

    runcmd:
      - mkdir -p /root/app
      - apt-get update
      - apt-get install -y python3-venv python3-full
      - python3 -m venv /root/app/venv
      - . /root/app/venv/bin/activate && pip install fastapi uvicorn
      - cd /root/app && nohup /root/app/venv/bin/uvicorn main:app --host 0.0.0.0 --port 80 &
    EOF
}

/*
# 로드밸런서 생성
resource "openstack_lb_loadbalancer_v2" "lb" {
  name              = "lkz-lb"
  vip_subnet_id     = var.subnet_id
  security_group_ids = [openstack_networking_secgroup_v2.web.id]
}

# 리스너 생성
resource "openstack_lb_listener_v2" "blue_listener" {
  name            = "${var.dev_name}-blue-listener"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  protocol        = "HTTP"
  protocol_port   = 80
}

# 블루 풀 생성
resource "openstack_lb_pool_v2" "blue_pool" {
  name        = "${var.dev_name}-blue-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.blue_listener.id
}

# 멤버 추가 (인스턴스들을 로드밸런서에 연결)
resource "openstack_lb_member_v2" "blue_members" {
  count         = var.create_instance ? 2 : 0
  pool_id       = openstack_lb_pool_v2.blue_pool.id
  address       = module.web_server[count.index].instance_addresses[0].fixed_ip_v4
  protocol_port = 80
  subnet_id     = var.subnet_id
}
*/