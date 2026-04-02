output "subnets" {
  description = "Список объектов подсетей"
  value       = local.subnets_list
}

output "subnets_by_zone" {
  description = "Подсети, сгруппированные по зонам"
  value       = local.subnets_by_zone
}

output "subnet_ids" {
  description = "Список ID подсетей"
  value       = var.subnet_ids
}