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
  security_groups = var.security_groups

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