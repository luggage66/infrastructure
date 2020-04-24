provider "google" {
  credentials = file(var.google_credentials_path)
}

provider "google-beta" {
  credentials = file(var.google_credentials_path)
}
