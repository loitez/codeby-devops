terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("../authorized_key.json")
  cloud_id  = "b1gklovqlr669uub3eci"
  folder_id = "b1gc8c43cugqbvm2070e"
  zone      = "ru-central1-a"
}