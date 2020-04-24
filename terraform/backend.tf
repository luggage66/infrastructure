terraform {
  backend "gcs" {
    bucket = "luggage66-terraform-admin"
    prefix = "terraform/state"
  }

  required_providers {
    helm = "~> 1.0"
  }
}