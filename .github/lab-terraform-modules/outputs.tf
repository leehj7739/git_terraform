output "security_group_id" {
  description = "생성된 보안 그룹의 ID"
  value       = openstack_networking_secgroup_v2.web.id
}

output "instance_ids" {
  description = "생성된 인스턴스들의 ID"
  value       = var.create_instance ? module.web_server[*].instance_id : []
}

output "instance_names" {
  description = "생성된 인스턴스들의 이름"
  value       = var.create_instance ? module.web_server[*].instance_name : []
}

output "instance_addresses" {
  description = "생성된 인스턴스들의 네트워크 주소"
  value       = var.create_instance ? module.web_server[*].instance_addresses : []
}


output "lb_vip" {
  description = "로드밸런서 VIP 주소"
  value       = openstack_lb_loadbalancer_v2.lb.vip_address
}

output "instance_ip" {
  description = "인스턴스의 IP 주소"
  value       = var.create_instance ? module.web_server[0].instance_addresses[0].fixed_ip_v4 : null
}

output "instance_ips" {
  description = "모든 인스턴스의 IP 주소"
  value       = var.create_instance ? [for server in module.web_server : server.instance_addresses[0].fixed_ip_v4] : []
}

output "loadbalancer_vip" {
  description = "로드밸런서 VIP 주소"
  value       = openstack_lb_loadbalancer_v2.lb.vip_address
}

output "loadbalancer_id" {
  description = "로드밸런서 ID"
  value       = openstack_lb_loadbalancer_v2.lb.id
}

output "loadbalancer_public_ip" {
  description = "로드밸런서의 퍼블릭 IP 주소"
  value       = "210.109.82.75"
}

