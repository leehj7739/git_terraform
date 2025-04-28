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
  tenant_name = var.tenant_name  # OpenStack 프로젝트 이름
  domain_name = "kc-kdt-sfacspace2025"
}

# Ubuntu 이미지 찾기
data "openstack_images_image_v2" "ubuntu" {
  name        = var.image_name
  most_recent = true
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

# 인스턴스 생성 (선택적)
resource "openstack_compute_instance_v2" "web" {
  count           = var.create_instance ? 1 : 0
  name            = "${var.dev_name}-web-server"
  image_id        = var.image_id != "" ? var.image_id : data.openstack_images_image_v2.ubuntu.id
  flavor_name     = var.flavor_name
  key_pair        = var.key_name
  security_groups = [openstack_networking_secgroup_v2.web.id]
  user_data       = <<-EOF
                    #!/bin/bash
                    apt-get update
                    apt-get install -y python3-pip
                    pip3 install fastapi uvicorn
                    mkdir -p /root/app
                    cat <<EOPY > /root/app/main.py
from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI()

# 배포 시각을 저장할 파일 경로
DEPLOY_TIME_FILE = "/root/app/deploy_time.txt"

# 배포 시각을 파일에 저장
def save_deploy_time():
    deploy_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(DEPLOY_TIME_FILE, "w") as f:
        f.write(deploy_time)

# 배포 시각을 파일에서 읽기
def get_deploy_time():
    if os.path.exists(DEPLOY_TIME_FILE):
        with open(DEPLOY_TIME_FILE, "r") as f:
            return f.read().strip()
    return "Deploy time not found"

# 서버 시작 시 배포 시각 저장
save_deploy_time()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/hello")
def read_hello():
    deploy_time = get_deploy_time()
    return {
        "message": "Hello from FastAPI!",
        "deploy_time": deploy_time,
        "current_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
EOPY
                    nohup uvicorn app.main:app --host 0.0.0.0 --port 80 --app-dir /root &
                    EOF

  network {
    name = "75ec8f1b-f756-45ec-b84d-6124b2bd2f2b_7c90b71b-e11a-48dc-83a0-e2bf7394bfb4"
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


module "web_server" {
  source = "./modules/compute"

  create_instance   = var.create_instance
  instance_name     = "${var.dev_name}-web-server"
  image_id          = var.image_id != "" ? var.image_id : data.openstack_images_image_v2.ubuntu.id
  flavor_name       = var.flavor_name
  key_name          = var.key_name
  security_groups   = [openstack_networking_secgroup_v2.web.id]
  network_name      = "75ec8f1b-f756-45ec-b84d-6124b2bd2f2b_7c90b71b-e11a-48dc-83a0-e2bf7394bfb4"
  root_volume_size  = var.root_volume_size
  user_data         = <<-EOF
                      #!/bin/bash
                      apt-get update
                      apt-get install -y python3-pip
                      pip3 install fastapi uvicorn
                      mkdir -p /root/app
                      cat <<EOPY > /root/app/main.py
from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI()

# 배포 시각을 저장할 파일 경로
DEPLOY_TIME_FILE = "/root/app/deploy_time.txt"

# 배포 시각을 파일에 저장
def save_deploy_time():
    deploy_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(DEPLOY_TIME_FILE, "w") as f:
        f.write(deploy_time)

# 배포 시각을 파일에서 읽기
def get_deploy_time():
    if os.path.exists(DEPLOY_TIME_FILE):
        with open(DEPLOY_TIME_FILE, "r") as f:
            return f.read().strip()
    return "Deploy time not found"

# 서버 시작 시 배포 시각 저장
save_deploy_time()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/hello")
def read_hello():
    deploy_time = get_deploy_time()
    return {
        "message": "Hello from FastAPI!",
        "deploy_time": deploy_time,
        "current_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
EOPY
                      nohup uvicorn app.main:app --host 0.0.0.0 --port 80 --app-dir /root &
                      EOF
}