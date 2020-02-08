resource "google_service_account" "circleci" {
  account_id   = "circleci"
  display_name = "CircleCI"
  project      = module.prod.project_id
}

resource "google_project_iam_member" "circleci-cloudbuild-agent" {
  member  = "serviceAccount:${google_service_account.circleci.email}"
  role    = "roles/cloudbuild.serviceAgent"
  project = module.prod.project_id
}

resource "google_service_account_key" "circleci" {
  service_account_id = google_service_account.circleci.name
}

output "circleci_google_application_credentials" {
  value = google_service_account_key.circleci.private_key
}
