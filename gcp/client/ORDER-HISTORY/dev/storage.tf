#set up terraform backend
terraform {
  backend "gcs" {
    bucket      = "order-history-terraform-state"
    prefix      = "terraform"
    credentials = "../../../credentials.json"
  }
}

resource "google_storage_bucket" "terraform-state" {
  name          = "order-history-terraform-state"
  storage_class = "STANDARD"
  location      = "US"
  labels = {
    name    = "order-history-terraform-state"
    project = "order-history-dev"
    mgmt    = "managed-by-terraform"
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                        = 0
      days_since_custom_time     = 0
      days_since_noncurrent_time = 0
      num_newer_versions         = 10
      with_state                 = "ARCHIVED"
    }
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                        = 0
      days_since_custom_time     = 0
      days_since_noncurrent_time = 60
      num_newer_versions         = 0
      with_state                 = "ANY"
    }
  }
  versioning {
    enabled = true
  }
}