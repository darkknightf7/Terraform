# Create a VPC Network
resource "google_compute_network" "vpc_network_dev" {
  name                    = "order-history-vpc-dev"
  auto_create_subnetworks = false
}

# Create a Subnetwork
resource "google_compute_subnetwork" "vpc_subnetwork_dev" {
  name          = "order-history-vpc-dev"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_dev.name
}

# Reserve an External Static IP
resource "google_compute_address" "static_ip_dev" {
  name   = "order-history-cloud-nat-ip-dev"
  region = "us-central1"
}

# Create a Cloud Router
resource "google_compute_router" "cloud_router_dev" {
  name    = "order-history-router-dev"
  network = google_compute_network.vpc_network_dev.name
  region  = "us-central1"
}

# Create a Cloud NAT
resource "google_compute_router_nat" "cloud_nat_dev" {
  name   = "order-history-nat-gateway-dev"
  router = google_compute_router.cloud_router_dev.name
  region = "us-central1"

  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.static_ip_dev.id]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  log_config {
    enable = false
    filter = "ALL"
  }
  subnetwork {
    name                     = "https://www.googleapis.com/compute/v1/projects/order-history-dev/regions/us-central1/subnetworks/order-history-vpc-dev"
    secondary_ip_range_names = []
    source_ip_ranges_to_nat = [
      "ALL_IP_RANGES",
    ]
  }
}