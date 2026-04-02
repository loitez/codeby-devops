variable "folder_id" {
  description = "Yandex Folder ID"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID подсетей для получения информации"
  type        = list(string)
}