resource "google_service_account" "accounts" {
  count = length(var.service_account_ids)

  project = var.project

  account_id   = var.service_account_ids[count.index]
  display_name = var.service_account_names[count.index] != "" ? var.service_account_names[count.index] : var.service_account_ids[count.index]
}

resource "google_service_account_key" "accounts" {
  count = length(var.service_account_ids)

  service_account_id = google_service_account.accounts[count.index].email
}

resource "google_project_iam_member" "accounts" {
  count = length(var.service_account_ids) > 0 ? length(var.roles) * length(var.service_account_ids) : 0

  project = var.role_project != "" ? var.role_project : var.project
  role    = var.roles[count.index % length(var.roles)]

  member = format(
    "serviceAccount:%s",
    google_service_account.accounts[floor(count.index / length(var.roles) % length(var.service_account_ids))].email,
  )
}

resource "google_service_account" "account" {
  count        = var.service_account_id != "" ? 1 : 0
  account_id   = var.service_account_id != "" ? var.service_account_id : "_"
  display_name = var.service_account_name != "" ? var.service_account_name : var.service_account_id != "" ? var.service_account_id : ""
  project      = var.project
}

resource "google_service_account_key" "account" {
  count              = var.service_account_id != "" ? 1 : 0
  service_account_id = google_service_account.account[0].email
}

resource "google_project_iam_member" "account" {
  count = var.service_account_id != "" ? length(var.roles) : 0

  project = var.role_project != "" ? var.role_project : var.project
  role    = var.roles[count.index]

  member = "serviceAccount:${google_service_account.account[0].email}"
}

