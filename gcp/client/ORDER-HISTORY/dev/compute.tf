resource "google_compute_instance" "bastion-dev" {
  name         = "order-history-bastion-dev"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["dev"]
  project      = var.project_id
  labels = {
    name        = "bastion-dev"
    project     = "order-history"
    mgmt        = "managed_by_terraform"
    environment = "prod"
    engagement  = "order-history"
    client      = "client"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240904"
      size  = "10"
    }
  }
  scheduling {
    provisioning_model = "STANDARD"
  }
  allow_stopping_for_update = true
  network_interface {
    network = "order-history-vpc-dev"
    # access_config {
    #   # Include this section to give the VM an external IP address
    #   nat_ip = google_compute_address.static_ip_dev.id
    # }
  }

  service_account {
    email  = "$email"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
