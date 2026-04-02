# Модуль 1: Получаем данные о подсетях
module "subnets" {
  source = "./modules/subnets"

  folder_id  = var.folder_id
  subnet_ids = var.subnet_ids
}

# Модуль 2: Создаём ВМ
module "vm" {
  source = "./modules/vm"

  name              = var.vm_name
  zone              = var.vm_zone
  network_id        = var.network_id
  subnets_by_zone   = module.subnets.subnets_by_zone
  ssh_public_key    = file(var.ssh_public_key_path)

  cores     = 2
  memory    = 2
  disk_size = 10
}