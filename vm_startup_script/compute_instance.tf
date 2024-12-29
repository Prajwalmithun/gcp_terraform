resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  # Startup script
  metadata_startup_script = file("./startup.sh")
  
  labels = {
    "environment" = "dev"
    "business" = "sales"
  }

  # To allow HTTP traffic
  tags = [ "http-server" ]
}



##############################
######### Outputs ############
##############################

# Compute Instance Name 
output "compute_instance_name" {
    value = google_compute_instance.vm_instance.name
}

# Internal IP of the instance
output "compute_instance_internal_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}

# Public IP of the instance 
output "compute_instance_public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}

# Labels attached
output "labels_attached" {
  value = google_compute_instance.vm_instance.labels
}

# Tags attached
output "tags_attached" {
  value = google_compute_instance.vm_instance.tags
}