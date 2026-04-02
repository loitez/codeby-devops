variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Folder ID"
  type        = string
}

variable "network_id" {
  description = "ID сети VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID подсетей в сети"
  type        = list(string)
}

variable "vm_zone" {
  description = "Зона для создания ВМ"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "lesson15-vm"
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH-ключу"
  type        = string
  default     = "~/.ssh/personal_key.pub"
}

