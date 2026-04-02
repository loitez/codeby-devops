data "yandex_vpc_subnet" "by_id" {
  for_each = toset(var.subnet_ids)
  subnet_id = each.value
}

locals {
  subnets_by_zone = {
    for id, subnet in data.yandex_vpc_subnet.by_id :
    subnet.zone => subnet
  }

  subnets_list = values(data.yandex_vpc_subnet.by_id)
}