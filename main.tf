provider "google" {
  region  = "us-central1"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "cluster-1"
  location = "us-central1-a"

  initial_node_count = 2

  node_config {
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  ##network    = var.network
  # subnetwork = var.subnetwork

  # IP Range for the cluster
  ip_allocation_policy {}
}
