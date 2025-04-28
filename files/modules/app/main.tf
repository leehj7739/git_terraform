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
  name            = "app-server-${count.index + 1}"
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_name
  security_groups = [var.security_group_name]

  network {
    name = var.network_name
  }

  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    volume_size           = 20
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
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