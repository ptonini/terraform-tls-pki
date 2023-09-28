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
  type = set(string)
  default = []
}

variable "clients" {
  type = set(string)
  default = []
}

variable "intermediate_cas" {
  type = set(string)
  default = []
}

variable "default_validity_period_hours" {
  default = 87600
}