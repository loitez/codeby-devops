variable "name" {
  description = "Имя ВМ"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
}

variable "network_id" {
  description = "ID сети VPC"
  type        = string
}

variable "subnets_by_zone" {
  description = "Подсети по зонам"
  type        = map(any)
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Память в ГБ"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Размер диска в ГБ"
  type        = number
  default     = 10
}

variable "image_family" {
  description = "Семейство образа"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "nat" {
  description = "Публичный IP"
  type        = bool
  default     = true
}