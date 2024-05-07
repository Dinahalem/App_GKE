#provider "google" {
  #project = "devops-v4-e2"
  #region  = "us-central1"
#}

#create bucket to store terraform state
terraform {
  backend "gcs" {
    bucket = "dina-tf-state-gkecicd"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }

  required_version = ">= 0.14"
}

