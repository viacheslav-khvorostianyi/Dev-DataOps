terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2"

  backend "gcs" {
    bucket      = "terraform-dev-data-ops"
    prefix      = "state"
  }
}

provider "google" {
    credentials = file("../tmp/creds.json")
    project     = var.project_id
    region      = var.gsp_region
    zone        = var.zone
}


resource "google_storage_bucket" "my_bucket" {
  name     = "test-bucket-12358"
  location = "EU"
  force_destroy = true
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-ingress"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_instance" "test_instance" {
  name         = "test-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["public"]
}


resource "google_bigquery_dataset" "example" {
  dataset_id = "test_dataset"
  location   = "EU"
}

resource "google_bigquery_table" "example_table" {
  dataset_id          = google_bigquery_dataset.example.dataset_id
  table_id            = "test_table"
  deletion_protection = false

  schema = jsonencode([
    {
      name = "id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "value"
      type = "INTEGER"
      mode = "NULLABLE"
    }
  ])
}