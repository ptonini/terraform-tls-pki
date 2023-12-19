locals {
  root_ca = coalesce(one(module.ca[*].this), var.root_ca)
}

module "ca" {
  source            = "ptonini/certificate/tls"
  version           = "~> v1.0.0"
  count             = var.root_ca == null ? 1 : 0
  common_name       = var.root_ca_common_name
  allowed_uses      = ["crl_signing", "cert_signing"]
  is_ca_certificate = true
}

module "intermediate_ca" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.intermediate_cas
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = each.value.validity_period_hours
  allowed_uses          = each.value.allowed_uses
  is_ca_certificate     = true
}

module "client" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.clients
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = each.value.validity_period_hours
  allowed_uses          = each.value.allowed_uses
}

module "server" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.servers
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = each.value.validity_period_hours
  allowed_uses          = each.value.allowed_uses
  ip_addresses          = each.value.ip_addresses
  dns_names             = each.value.dns_names
  uris                  = each.value.uris
}