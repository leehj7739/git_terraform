output "instance_id" {
  description = "생성된 인스턴스의 ID"
  value       = var.create_instance ? openstack_compute_instance_v2.web[0].id : null
}

output "instance_name" {
  description = "생성된 인스턴스의 이름"
  value       = var.create_instance ? openstack_compute_instance_v2.web[0].name : null
}

output "instance_addresses" {
  description = "생성된 인스턴스의 네트워크 주소"
  value       = var.create_instance ? openstack_compute_instance_v2.web[0].network : null
}

output "instance_port_id" {
  description = "생성된 인스턴스의 네트워크 포트 ID"
  value       = var.create_instance ? openstack_compute_instance_v2.web[0].network[0].port : null
}

output "security_group_id" {
  description = "생성된 보안 그룹의 ID"
  value       = var.security_groups[0]
}

output "public_ip" {
  description = "인스턴스의 공인 IP 주소"
  value       = openstack_compute_instance_v2.web[0].access_ip_v4
}

