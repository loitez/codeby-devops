resource "yandex_vpc_network" "default_2" {
  name = "terraform-network-2"
}

resource "yandex_vpc_subnet" "public_2" {
  name           = "public-subnet-2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default_2.id
  v4_cidr_blocks = ["10.1.1.0/24"]
}

resource "yandex_vpc_subnet" "private_2" {
  name           = "private-subnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default_2.id
  v4_cidr_blocks = ["10.1.2.0/24"]
}