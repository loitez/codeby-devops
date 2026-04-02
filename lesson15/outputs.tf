output "available_subnets" {
  description = "Доступные подсети по зонам"
  value       = module.subnets.subnets_by_zone
}

output "vm_public_ip" {
  description = "Публичный IP созданной ВМ"
  value       = module.vm.public_ip
}

output "vm_instance_id" {
  description = "ID созданной ВМ"
  value       = module.vm.instance_id
}

output "vm_zone" {
  description = "Зона, в которой создана ВМ"
  value       = module.vm.zone
}