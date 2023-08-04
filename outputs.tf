output "ca_cert_pem" {
  value = local.root_ca.cert_pem
}

output "intermediate_ca" {
  value = { for k, v in module.intermediate_ca : k => v.this }
}

output "client" {
  value = { for k, v in module.client : k => v.this }
}

output "server" {
  value = { for k, v in module.server : k => v.this }
}
