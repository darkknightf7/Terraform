resource "google_cloud_scheduler_job" "job1" {
  name             = "PCRX_import_api_dev_call"
  description      = "calls the db every 3 hours to pull latest records"
  schedule         = "0 */3 * * *"
  time_zone        = "Etc/UTC"
  attempt_deadline = "600s"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://importapi-1212312314.us-central1.run.app/pcrx/run-procedureDate"
    body = base64encode("{\"startTime\" : \"{{.ExecutionTime}}\", \"endTime\" : \"{{.ExecutionTime}}\"}")
    headers = {
      "Content-Type" = "application/json",
      "User-Agent"   = "Google-Cloud-Scheduler",
      "isManual"     = "false"
    }
  }
}


resource "google_cloud_scheduler_job" "job2" {
  name             = "PCRX_retrieveapi_health_check_dev"
  description      = "checks the status of server every 10 min"
  schedule         = "*/10 * * * *"
  time_zone        = "Etc/UTC"
  attempt_deadline = "600s"

  retry_config {
    retry_count = 5
  }

  http_target {
    http_method = "GET"
    uri         = "https://proxy-apim-gateway-42fwdf23.uc.gateway.dev/health"
    headers = {
      "User-Agent" = "Google-Cloud-Scheduler",
      "x-api-key"  = "$API_KEY"
    }
  }
}