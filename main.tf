locals {
  default_allowed_uses = {
    ca     = ["crl_signing", "cert_signing"]
    client = ["client_auth"]
    server = ["server_auth"]
  }
  root_ca = {
    cert_pem        = var.root_ca == null ? module.ca[0].this.cert_pem : var.root_ca.cert_pem
    private_key_pem = var.root_ca == null ? module.ca[0].this.private_key_pem : var.root_ca.private_key_pem
  }
}

module "ca" {
  source            = "ptonini/certificate/tls"
  version           = "~> v1.0.0"
  count             = var.root_ca == null ? 1 : 0
  common_name       = var.root_ca_common_name
  allowed_uses      = local.default_allowed_uses.ca
  is_ca_certificate = true
}

module "intermediate_ca" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.intermediate_cas
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = try(each.value["validity_period_hours"], var.default_validity_period_hours)
  allowed_uses          = try(each.value["allowed_uses"], local.default_allowed_uses.ca)
  is_ca_certificate     = true
}

module "client" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.clients
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = try(each.value["validity_period_hours"], var.default_validity_period_hours)
  allowed_uses          = try(each.value["allowed_uses"], local.default_allowed_uses.client)
}

module "server" {
  source                = "ptonini/certificate/tls"
  version               = "~> v1.0.0"
  for_each              = var.servers
  signer                = local.root_ca
  common_name           = each.key
  validity_period_hours = try(each.value["validity_period_hours"], var.default_validity_period_hours)
  ip_addresses          = try(each.value["ip_addresses"], null)
  dns_names             = try(each.value["dns_names"], null)
  uris                  = try(each.value["uris"], null)
  allowed_uses          = try(each.value["allowed_uses"], local.default_allowed_uses.server)
}