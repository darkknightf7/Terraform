terraform {
  required_version = ">=1.1.7"
  required_providers {
    google = {
      version = "~>6.8"
    }
    google-beta = {
      version = "~>6.8"
    }
    random = {
      version = "~>3.3.1"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.project_id
  region      = var.region
  zone        = "us-central1-a"
}

provider "google-beta" {
  credentials = file(var.gcp_auth_file)
  project     = var.project_id
  region      = var.region
  zone        = "us-central1-a"
}

#resource "google_compute_network" "network" {
#  project                 = var.project_id
#  name                    = "default"
#}

#enable APIs in gcp project
resource "google_project_service" "gcp_services" {
  for_each = local.gcp_service_list
  project  = var.project_id
  service  = each.value.service
}
