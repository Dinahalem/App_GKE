resource "google_container_registry" "my_registry" {
  name = "gke-repo" 
}

output "gcr_url" {
  value = google_container_registry.my_registry.name
}
