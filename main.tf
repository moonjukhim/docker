provider "google" {
  region  = "us-central1"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "cluster-1"
  location = "us-central1"

  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  ##network    = var.network
  # subnetwork = var.subnetwork

  # IP Range for the cluster
  ip_allocation_policy {}
}
