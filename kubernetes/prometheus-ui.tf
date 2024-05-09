resource "google_service_account" "prometheus_ui" {
  account_id = "prometheus-ui"
}

resource "google_service_account_iam_member" "prometheus_ui" {
  service_account_id = google_service_account.prometheus_ui.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:gke-cicd-422619.svc.id.goog[monitoring/prometheus-ui]"
}

resource "google_project_iam_member" "prometheus_ui" {
  project = "gke-cicd-422619"
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.prometheus_ui.email}"

  depends_on = [
    google_service_account.prometheus_ui
  ]
}
