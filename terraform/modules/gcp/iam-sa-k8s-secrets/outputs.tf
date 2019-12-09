output "email" {
  value = var.service_account_id != "" ? google_service_account.account.0.email : ""
}

output "emails" {
  value = google_service_account.accounts.*.email
}

output "private_key" {
  value = base64decode(
    concat(google_service_account_key.account.*.private_key, ["MQ=="])[0]
  )
  sensitive = true
}

data "template_file" "private_keys" {
  count    = length(var.service_account_ids)
  template = "$${key}"
  vars = {
    key = base64decode(
      concat(google_service_account_key.accounts.*.private_key, ["MQ=="])[count.index],
    )
  }
}

output "private_keys" {
  value     = data.template_file.private_keys.*.rendered
  sensitive = true
}

output "secret_name" {
  value = var.secret_name
}

output "secret_names" {
  value = var.secret_names
}

output "secret_key" {
  value = var.secret_key != "" ? var.secret_key : "application_default_credentials.json"
}

output "secret_keys" {
  value = var.secret_keys
}

