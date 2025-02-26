resource "google_sql_database_instance" "cust-orders-sql-dev" {
  name             = "cust-orders-sql-dev"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = var.region
  settings {
    tier                        = "db-custom-2-8192"
    deletion_protection_enabled = true
    time_zone                   = "UTC"
    edition                     = "ENTERPRISE"
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    # user_labels = {
    #   name        = "cust-orders-sql-dev"
    #   project     = "ORDER-HISTORY"
    #   mgmt        = "managed_by_terraform"
    #   environment = "dev"
    #   engagement  = "ORDER-HISTORY"
    #   client      = "client"
    # }
    availability_type = "ZONAL"
    location_preference {
      zone = "us-central1-b"
    }
    ip_configuration {
      enable_private_path_for_google_cloud_services = false
      ipv4_enabled                                  = false
      private_network                               = "projects/order-history-dev/global/networks/order-history-vpc-dev"
      # dynamic "authorized_networks" {
      #   for_each = local.sql_authorized_nets
      #   iterator = sql_authorized_nets
      #   content {
      #     name  = sql_authorized_nets.key
      #     value = sql_authorized_nets.value
      #   }
      # }
    }
    #    database_flags {
    #      name  = "sql_mode"
    #      value = "ALLOW_INVALID_DATES,ANSI_QUOTES,ERROR_FOR_DIVISION_BY_ZERO,HIGH_NOT_PRECEDENCE,IGNORE_SPACE,NO_BACKSLASH_ESCAPES,NO_ENGINE_SUBSTITUTION,NO_UNSIGNED_SUBTRACTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,PIPES_AS_CONCAT,REAL_AS_FLOAT,STRICT_ALL_TABLES,STRICT_TRANS_TABLES,ANSI,TRADITIONAL,NO_AUTO_CREATE_USER,NO_FIELD_OPTIONS,NO_KEY_OPTIONS,NO_TABLE_OPTIONS,DB2,MAXDB,MSSQL,MYSQL323,MYSQL40,ORACLE,POSTGRESQL"
    #    }
    backup_configuration {
      enabled  = "true"
      location = "us"
      #	  binary_log_enabled             = "true"
      #	  start_time                     = "02:00"
      #	  transaction_log_retention_days = "7"
      #	  backup_retention_settings {
      #	    retained_backups             = "7"
      #	  }
    }

  }
}