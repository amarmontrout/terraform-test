variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}
