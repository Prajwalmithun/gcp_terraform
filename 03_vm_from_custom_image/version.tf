terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.14.1"
    }
  }
}

provider "google" {
  # Configuration options
  project = "thematic-carver-439505-s0"
  region = "us-west1"
}