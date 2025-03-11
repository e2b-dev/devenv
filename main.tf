terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  project     = "e2b-staging-wendt-robert"
  region      = "us-central1"
  zone        = "us-central1-a"
}


variable "username" {
  type    = string
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

# allow ssh from anywhere
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}


# create a static ip address
resource "google_compute_address" "external_ip" {
  name = "terraform-external-ip"
}



# Create an instance template
resource "google_compute_instance_template" "vm_template" {
  name         = "terraform-instance-template"
  machine_type = "e2-medium" # $25 / month
  # machine_type = "e2-standard-4" # $100 / month
  tags         = ["web", "dev"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-minimal-2404-noble-amd64-v20250306"
    boot         = true
    auto_delete  = true
    disk_size_gb = 50
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    # use the external ip address
    access_config {
      # Include this section to give the VM an external IP address
      nat_ip = google_compute_address.external_ip.address
    }
  }

  metadata = {
    startup-script = templatefile("./startup.sh", {
      username = var.username
    })
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

# Outputs
output "template_id" {
  value = google_compute_instance_template.vm_template.id
}

output "template_name" {
  value = google_compute_instance_template.vm_template.name
}

output "external_ip" {
  value = google_compute_instance_template.vm_template.network_interface[0].access_config[0].nat_ip
}