output "instance_id" {
  description = "App instance ID"
  value       = openstack_compute_instance_v2.app[0].id
}

output "instance_ip" {
  description = "App instance IP"
  value       = openstack_networking_floatingip_v2.app[0].address
}

output "all_app_ips" {
  description = "The floating IPs of all instances"
  value       = openstack_networking_floatingip_v2.app[*].address
} 