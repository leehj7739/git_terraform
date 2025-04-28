region       = "kr-central-2"
project_name = "kc-sfacspace"
dev_name = "lkz"

# 네트워크 설정
network_name = "sfacspace-default"
network_id = "your-network-id"  # 실제 네트워크 ID로 교체
external_network_id = "your-external-network-id"  # 실제 외부 네트워크 ID로 교체
subnet_cidr = "192.168.1.0/24"
floating_ip_pool = "public"

# 인스턴스 설정
create_instance   = true
image_name        = "Ubuntu 24.04"
image_id          = "6f8f7e1c-b801-46c6-940c-603ffc05247a"
flavor_name       = "t1i.small"
key_name          = "lhj-kc-key"
root_volume_size  = 12

# 추가 볼륨 설정
create_data_volume = false
data_volume_size   = 50

# 오브젝트 스토리지 설정
create_s3_bucket   = false
s3_bucket_suffix   = "unique-suffix-12345" 

# 환경 설정
environment = "blue"
security_group_name = "default"
app_repository = "https://github.com/leehj7739/git_terraform.git"

