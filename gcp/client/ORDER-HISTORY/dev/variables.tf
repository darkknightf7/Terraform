locals {
  sql_authorized_nets = {
    # dev     = google_compute_address.static-dev.address
    # qa      = google_compute_address.static-qa.address
    # ssh     = google_compute_address.static-ssh.address
    # dx      = google_compute_address.static-dx.address
  }
  common_labels = {
    project     = "ORDER-HISTORY"
    mgmt        = "managed_by_terraform"
    environment = "dev"
    engagement  = "ORDER-HISTORY"
    client      = "client"
  }
  # all_instance_addresses = {
  #  dev = google_compute_address.static-dev.address
  #  qa  = google_compute_address.static-qa.address
  #  ssh = google_compute_address.static-ssh.address
  # }

  timestamp       = timestamp()
  timestamp_short = replace(local.timestamp, "/[ TZ:]/", "")
}



# Bastion + Dev + QA + DataExchange environment SSH keys
# No two usernames can be the same. 
variable "ssh_keys" {
  type = map(any)
  default = {
   $user_ssh_key
  }
}

variable "client_vpn_sources" {
  type = list(any)
  default = [
    "$IP Address"
  ]
}

variable "client_vpn_sources" {
  type = list(any)
  default = [
     "$IP Address"
  ]
}

variable "bitbucket_ssh_sources" {
  type = list(any)
  default = [
     "$IP Address"
  ]
}


variable "environment" {
  default = "dev"
  type    = string
}

# variable "zone" {
#   default = "us-central1-b"
#   type    = string
# }

variable "region" {
  default = "us-central1"
  type    = string
}

variable "project" {
  default = "client Order History - Dev"
  type    = string
}

variable "project_id" {
  default = "order-history-dev"
  type    = string
}

variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "network" {
  default = "default"
  type    = string
}

#variable "vpc" {
#  default = "default"
#}
#
#variable "vpc_subnets" {
#  default = "default"
#}

variable "gcp_auth_file" {
  type    = string
  default = "../../../credentials.json"
}


resource "random_id" "db_name_suffix" {
  byte_length = 4
}


locals {
  gcp_service_list = {
    identitytoolkit = {
      "service" = "identitytoolkit.googleapis.com"
    },
    securetoken = {
      "service" = "securetoken.googleapis.com"
    },
    appengine = {
      "service" = "appengine.googleapis.com"
    },
    logging = {
      "service" = "logging.googleapis.com"
    },
    oslogin = {
      "service" = "oslogin.googleapis.com"
    },
    pubsub = {
      "service" = "pubsub.googleapis.com"
    },
    cloudresourcemanager = {
      "service" = "cloudresourcemanager.googleapis.com"
    },
    compute = {
      "service" = "compute.googleapis.com"
    },
    dns = {
      "service" = "dns.googleapis.com"
    },
    filestore = {
      "service" = "file.googleapis.com"
    }
  }
}



#variable "apache_startup_script" {
#  type = any
#}