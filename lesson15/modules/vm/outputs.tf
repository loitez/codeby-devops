output "instance_id" {
  description = "ID ВМ"
  value       = length(yandex_compute_instance.vm) > 0 ? yandex_compute_instance.vm[0].id : null
}

output "public_ip" {
  description = "Публичный IP"
  value       = length(yandex_compute_instance.vm) > 0 ? yandex_compute_instance.vm[0].network_interface[0].ip_address : null
}

output "zone" {
  description = "Зона ВМ"
  value       = var.zone
}