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
  metadata_startup_script = file("./startup-base.sh")
  
  labels = {
    "environment" = "dev"
    "business" = "sales"
  }

  # To allow HTTP traffic
  tags = [ "http-server" ]

  # Stops the instance after creation
  desired_status = "TERMINATED" 
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

# Boot Disk
output "boot_disk" {
  value = google_compute_instance.vm_instance.boot_disk[0].source
  sensitive = false
}

# Create Custom image
resource "google_compute_image" "custom_image" {
  name = "custom-image"

  source_disk = google_compute_instance.vm_instance.boot_disk[0].source

  depends_on = [ google_compute_instance.vm_instance ]
}

# Create new instance using the custom image
resource "google_compute_instance" "vm_instance_custom" {
  name         = "instance-from-custom-image"
  machine_type = "e2-micro"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = google_compute_image.custom_image.self_link
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  # Startup script
  metadata_startup_script = file("./startup-custom-image.sh")
  
  labels = {
    "environment" = "dev"
    "business" = "sales"
  }

  # To allow HTTP traffic
  tags = [ "http-server" ]

  depends_on = [ google_compute_instance.vm_instance, google_compute_image.custom_image ]
 
}