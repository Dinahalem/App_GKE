# lb.tf
resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "example-forwarding-rule"
  target     = google_compute_target_http_proxy.proxy.self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "example-target-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_url_map" "url_map" {
  name            = "example-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_backend_service" "backend_service" {
  name = "example-backend-service"
  port = "80"

  # Using the instance_group_urls from the managed instance group of the primary node pool
  backend {
    group = google_container_node_pool.primary_nodes.instance_group_urls[0]
  }

  # Adding backend for the secondary node pool
  backend {
    group = google_container_node_pool.secondary_nodes.instance_group_urls[0]
  }
}


