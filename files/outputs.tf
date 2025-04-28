output "app_instance_ids" {
  description = "App instance IDs"
  value       = module.app_server.instance_id
}

output "app_instance_ips" {
  description = "App instance IPs"
  value       = module.app_server.instance_ip
}

output "security_group_id" {
  description = "생성된 보안 그룹의 ID"
  value       = openstack_networking_secgroup_v2.web.id
}

output "data_volume_id" {
  description = "생성된 데이터 볼륨의 ID"
  value       = var.create_data_volume ? openstack_blockstorage_volume_v3.data[0].id : null
}

output "storage_container_name" {
  description = "생성된 오브젝트 스토리지 컨테이너 이름"
  value       = var.create_s3_bucket ? openstack_objectstorage_container_v1.storage[0].name : null
} 