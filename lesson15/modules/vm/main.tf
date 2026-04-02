data "yandex_compute_image" "vm_image" {
  family = var.image_family
}

locals {
  selected_subnet = lookup(var.subnets_by_zone, var.zone, null)
  subnet_id       = local.selected_subnet != null ? local.selected_subnet.id : null
  can_create      = local.selected_subnet != null
}

resource "yandex_compute_instance" "vm" {
  count = local.can_create ? 1 : 0

  name        = var.name
  platform_id = "standard-v1"
  zone        = var.zone
  hostname    = var.name

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.image_id
      type     = "network-hdd"
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = local.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}