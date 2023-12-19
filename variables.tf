variable "root_ca" {
  default = null
  type = object({
    cert_pem        = string
    private_key_pem = string
  })
}

variable "root_ca_common_name" {
  default = null
}

variable "servers" {
  type = map(object({
    validity_period_hours = optional(number)
    allowed_uses          = optional(set(string), ["server_auth"])
    ip_addresses          = optional(set(string))
    dns_names             = optional(set(string))
    uris                  = optional(set(string))
  }))
  default = {}
}

variable "clients" {
  type = map(object({
    validity_period_hours = optional(number)
    allowed_uses          = optional(set(string), ["client_auth"])
  }))
  default = {}
}

variable "intermediate_cas" {
  type = map(object({
    validity_period_hours = optional(number)
    allowed_uses          = optional(set(string), ["crl_signing", "cert_signing"])
  }))
  default = {}
}