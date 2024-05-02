#enable compute API
resource "google_project_service" "compute" {
  project = "devops-v4-e2"
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  project = "devops-v4-e2"
  service = "container.googleapis.com"
}


resource "google_compute_network" "main" {
  project                         = "devops-v4-e2"
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

