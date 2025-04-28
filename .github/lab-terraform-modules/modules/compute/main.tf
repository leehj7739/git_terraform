resource "openstack_compute_instance_v2" "web" {
  count           = var.create_instance ? 1 : 0
  name            = var.instance_name
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_name
  security_groups = var.security_groups

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
