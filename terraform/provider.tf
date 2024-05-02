provider "google" {
  project = "<project-id>"
  region  = "us-central1"
}

#create bucket to store terraform state
terraform {
  backend "gcs" {
    bucket = "dina-tf-state-staging"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
