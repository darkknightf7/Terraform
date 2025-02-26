resource "google_cloud_run_v2_service" "ordersimportapidev" {
  name           = "ordersimportapidev"
  location       = "us-central1"
  client         = "gcloud"
  client_version = "492.0.0"

  template {
    containers {
      image = "gcr.io/order-history-dev/orders/ordersimportapidev:dasdasdaasdasd-dev"
      name  = "ordersimportapidev-1"
      env {
        name  = "SOURCE_DB_NAME"
        value = "DM_Mapping_Log"
      }
      env {
        name  = "SOURCE_DB_PASSWORD"
        value = "projects/dasdasdaasdas/secrets/SOURCE_DB_PASSWORD:latest"
      }
      env {
        name  = "SOURCE_DB_USERNAME"
        value = "$EMAIL"
      }
      env {
        name  = "SOURCE_ENABLE_ENCRYPT"
        value = "false"
      }
      env {
        name  = "SOURCE_SERVER_IP"
        value = "35.202.118.22"
      }
      env {
        name  = "TARGET_BATCH_SIZE"
        value = "500"
      }
      env {
        name  = "TARGET_DB_PASSWORD"
        value = "projects/450441276983/secrets/TARGET_DB_PASSWORD:latest"
      }
      env {
        name  = "TARGET_DB_USERNAME"
        value = "orderhistorydev"
      }
      env {
        name  = "TARGET_ENABLE_ENCRYPT"
        value = "false"
      }
      env {
        name  = "TARGET_SQL_INSTANCE_IP"
        value = "10.205.128.3"
      }
      env {
        name  = "TARGET_SQL_INSTANCE_NAME"
        value = "order-history-dev:us-central1:cust-orders-sql-dev"
      }
      env {
        name  = "TARGET_TABLE_NAME"
        value = "OrderHistoryDetails"
      }
      env {
        name  = "spring.profiles.active"
        value = "dev"
      }

      # Optional: Configure resources
      resources {
        cpu_idle          = true
        startup_cpu_boost = true
        limits = {
          memory = "1Gi"
          cpu    = "2"
        }
      }
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }
    }
    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [
        "order-history-dev:us-central1:cust-orders-sql-dev"]
      }
    }
    vpc_access {
      network_interfaces {
        network    = "order-history-vpc-dev"
        subnetwork = "order-history-vpc-dev"
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}


resource "google_cloud_run_v2_service" "ordersretrieveapidev" {
  name           = "ordersretrieveapidev"
  location       = "us-central1"
  client         = "gcloud"
  client_version = "492.0.0"

  template {
    containers {
      image = "gcr.io/order-history-dev/orders/ordersretrieveapidev:latest-dev"
      name  = "ordersretrieveapidev-1"

      env {
        name  = "spring.profiles.active"
        value = "dev"
      }


      # Optional: Configure resources
      resources {
        cpu_idle          = true
        startup_cpu_boost = true
        limits = {
          memory = "1Gi"
          cpu    = "2"
        }
      }
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }
    }
    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [
        "order-history-dev:us-central1:pcrx-cust-orders-sql-dev"]
      }
    }
    vpc_access {
      network_interfaces {
        network    = "order-history-vpc-dev"
        subnetwork = "order-history-vpc-dev"
      }
    }
  }

}
