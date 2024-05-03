resource "google_container_registry_repository" "my_repository" {
  project  = "${var.project_id}" 
  name     = "gke-repo"         
}

