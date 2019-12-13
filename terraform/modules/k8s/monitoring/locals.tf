locals {
  grafana_host = "${var.granafa_subdomain}.${var.base_hostname}"
  grafana_path = var.grafana_path
  grafana_identifier = "https://${local.grafana_host}"
  grafana_root_url = "${local.grafana_identifier}${local.grafana_path}"
  grafana_auth_callback = "${local.grafana_root_url}/login/generic_oauth"
  grafana_log_level = var.grafana_log_level
  grafana_oauth = {
    client_id = var.oauth_client_id
    client_secret = var.oauth_client_secret
    scopes = "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email"
    auth_url = "https://accounts.google.com/o/oauth2/auth"
    token_url = "https://accounts.google.com/o/oauth2/auth"
    logout_url = "https://${local.grafana_host}"
    name = "Google"
  }
}
