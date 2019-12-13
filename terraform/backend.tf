terraform {
  backend "gcs" {
    bucket = "luggage66-terraform-admin"
    prefix = "terraform/state"
  }
}