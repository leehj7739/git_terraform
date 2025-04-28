output "instance_id" {
  description = "인스턴스 ID"
  value       = openstack_compute_instance_v2.web[0].id
}

output "instance_name" {
  description = "인스턴스 이름"
  value       = openstack_compute_instance_v2.web[0].name
}

output "public_ip" {
  description = "인스턴스의 공인 IP 주소"
  value       = openstack_compute_instance_v2.web[0].access_ip_v4
}
