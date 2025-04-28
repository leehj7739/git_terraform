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

output "data_volume_id" {
  description = "생성된 데이터 볼륨의 ID"
  value       = var.create_data_volume ? openstack_blockstorage_volume_v3.data[0].id : null
}

output "storage_container_name" {
  description = "생성된 오브젝트 스토리지 컨테이너 이름"
  value       = var.create_s3_bucket ? openstack_objectstorage_container_v1.storage[0].name : null
}

