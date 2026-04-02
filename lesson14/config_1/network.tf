# Используем стандартную сеть, которая уже существует в каталоге
data "yandex_vpc_network" "default" {
  name = "default"
}

# Публичная подсеть (в зоне ru-central1-a)
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet-c1" # Уникальное имя для config_1
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Приватная подсеть (в зоне ru-central1-b)
resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet-c1" # Уникальное имя для config_1
  zone           = "ru-central1-b"
  network_id     = data.yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}