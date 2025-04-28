terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
  }
}

resource "openstack_compute_instance_v2" "app" {
  count           = var.instance_count
  name            = "${var.environment}-app-${count.index + 1}"
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_name
  security_groups = [var.security_group_name]

  network {
    name = var.network_name
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3-pip git
    mkdir -p /app
    git clone ${var.app_repository} /app
    cd /app
    pip3 install -r requirements.txt
    chmod 777 /app
    uvicorn main:app --host 0.0.0.0 --port 8000
  EOF
}

resource "openstack_networking_floatingip_v2" "app" {
  count = var.instance_count
  pool  = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "app" {
  count       = var.instance_count
  floating_ip = openstack_networking_floatingip_v2.app[count.index].address
  instance_id = openstack_compute_instance_v2.app[count.index].id
}