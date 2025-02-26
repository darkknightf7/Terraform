# Define an API in GCP API Gateway
resource "google_api_gateway_api" "my_api" {
  provider     = google-beta
  api_id       = "proxy-apim"
  display_name = "proxy-apim"
}

# Define an API config using an OpenAPI spec file
resource "google_api_gateway_api_config" "my_api_config" {
  provider      = google-beta
  api           = google_api_gateway_api.my_api.api_id
  api_config_id = "proxy-apim-config-1-0-1"
  openapi_documents {
    document {
      path     = "swagger.yaml"
      contents = filebase64("swagger.yaml")
    }
  }
}

# Create an API Gateway instance
resource "google_api_gateway_gateway" "my_gateway" {
  provider     = google-beta
  gateway_id   = "apim-gateway"
  display_name = "proxy-apim-gateway"
  api_config   = google_api_gateway_api_config.my_api_config.id
  region       = "us-central1"
}