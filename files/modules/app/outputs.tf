output "app_ip" {
  description = "The floating IP of the first instance"
  value       = openstack_networking_floatingip_v2.app[0].address
}

output "all_app_ips" {
  description = "The floating IPs of all instances"
  value       = openstack_networking_floatingip_v2.app[*].address
} 