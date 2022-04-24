
// Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = false
}

// Create Subnet
resource "google_compute_subnetwork" "app" {
  name          = "${var.project_name}-app-subnet"
  ip_cidr_range = "192.168.0.0/24"
  network       = "${var.project_name}-vpc"
  depends_on    = [google_compute_network.vpc]
  region        = var.region
}

// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.project_name}-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-9000"]
  }

  source_tags = ["web"]

  source_ranges = ["0.0.0.0/0"]
}

//create vm instance 
resource "google_compute_instance" "vm_instance" {
  name         = "satvika-vm"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

// create a storage_bucket

resource "google_storage_bucket" "my_bucket" {
  name     = var.project_name
  location = var.region
  project  = "devproject-348110"
}
