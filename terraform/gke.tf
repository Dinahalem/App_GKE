variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}
# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke-primary"
  location = "us-central1-f"
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  node_config {
    disk_size_gb = 50  # Adjust the disk size as needed, reducing it to 50 GB
    disk_type    = "pd-standard"  # Use standard persistent disks
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = "us-central1-f"
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    disk_size_gb = 50  # Adjust the disk size as needed, reducing it to 50 GB
    disk_type    = "pd-standard"  # Use standard persistent disks
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}


# Second GKE cluster
resource "google_container_cluster" "secondary" {
  name     = "${var.project_id}-gke-secondary"
  #location = "us-central1-f"
  location = "us-east4-b"

  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet_secondary.name
  #subnetwork = google_compute_subnetwork.subnet.name

  node_config {
  disk_size_gb = 50  # Adjust the disk size as needed, reducing it to 50 GB
  disk_type    = "pd-standard"  # Use standard persistent disks
  }
}

# Node pool for the second cluster
resource "google_container_node_pool" "secondary_nodes" {
  name       = "${google_container_cluster.secondary.name}-nodes"
  location   = "us-east4-b"
  cluster    = google_container_cluster.secondary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    disk_size_gb = 50  # Adjust the disk size as needed, reducing it to 50 GB
    disk_type    = "pd-standard"  # Use standard persistent disks
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}
