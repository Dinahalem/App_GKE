resource "google_service_account" "collector" {
  account_id = "collector"
}

resource "google_service_account_iam_member" "collector" {
  service_account_id = google_service_account.collector.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:gke-cicd-422619.svc.id.goog[gmp-system/collector]"
}

resource "google_project_iam_member" "collector" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.collector.email}"

  depends_on = [
    google_service_account.collector
  ]
}
