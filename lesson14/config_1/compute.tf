data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm_public" {
  name        = "public-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "public-vm"

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
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true # Публичный IP для доступа и провиженера
    security_group_ids = [yandex_vpc_security_group.sg_public.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/personal_key.pub")}" # Используйте ваш ключ или создайте пару
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/personal_key") # Путь к вашему приватному ключу
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

resource "yandex_compute_instance" "vm_private" {
  name        = "private-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"
  hostname    = "private-vm"

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
    subnet_id  = yandex_vpc_subnet.private.id
    nat        = true # Включаем для работы провиженера (в продакшене лучше через bastion)
    security_group_ids = [yandex_vpc_security_group.sg_private.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/personal_key.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/personal_key")
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