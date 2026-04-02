data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

# ============================================================================
# РЕСУРС ДЛЯ ИМПОРТА (ручная ВМ)
# Замените <ID_ручной_ВМ> на реальный ID после создания ВМ вручную
# ============================================================================
resource "yandex_compute_instance" "manual_import_vm" {
  name        = "manual-vm-for-import"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "manual-vm-for-import"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_2.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_public_2.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/personal_key.pub")}"
  }
}

# ============================================================================
# ОСТАЛЬНЫЕ ВМ (закомментированы, т.к. не нужны для задания по импорту)
# Раскомментируйте, если нужно создать полную инфраструктуру во config_2
# ============================================================================

/*
resource "yandex_compute_instance" "vm_public_2" {
  name        = "public-vm-2"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "public-vm-2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_2.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_public_2.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.network_interface[0].ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

resource "yandex_compute_instance" "vm_private_2" {
  name        = "private-vm-2"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"
  hostname    = "private-vm-2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_2.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_private_2.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.network_interface[0].ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
*/