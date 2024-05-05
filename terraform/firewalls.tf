#Firewall
#This firewall will allow sshing to the compute instances within VPC.

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  #network = google_compute_network.main.name
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  #network = "default"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "allow-external" {
  name    = "allow-external"
  #network = "default"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
