variable "deployment_region" {
    type = string
}

variable "project_id" {
    type = string
}

variable "dataset_id" {
    type = string
}

resource "google_bigquery_connection" "connection" {
  connection_id = "explore_assistant_llm"
  project       = var.project_id
  location      = var.deployment_region
  cloud_resource {}

    # Add this block to handle the case when the connection already exists
  lifecycle {
    create_before_destroy = true
  }
}

# IAM for connection to be able to execute vertex ai queries through BQ
resource "google_project_iam_member" "bigquery_connection_remote_model" {
  project    = var.project_id
  role       = "roles/aiplatform.user"
  member     = format("serviceAccount:%s", google_bigquery_connection.connection.cloud_resource[0].service_account_id)
}

resource "google_bigquery_job" "create_bq_model_llm" {
  job_id = "create_looker_llm_model-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  query {
    query              = <<EOF
CREATE MODEL `${var.dataset_id}.explore_assistant_llm` #RG removed or replace so I can create multiple.
REMOTE WITH CONNECTION `${google_bigquery_connection.connection.name}` 
OPTIONS (endpoint = 'gemini-pro')
EOF  
    create_disposition = ""
    write_disposition  = ""
    allow_large_results = false
    flatten_results = false
    maximum_billing_tier = 0
    schema_update_options = [ ]
    use_legacy_sql = false
  }

  location = var.deployment_region

   # Add this block to handle the case when the model already exists
  lifecycle {
    create_before_destroy = true
  }
}

