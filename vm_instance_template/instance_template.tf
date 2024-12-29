resource "google_compute_instance_template" "instance_template" {
  name = "instance-template"
  description = "This instance template is used to creted VM instances"

  labels = {
    "environment" = "dev"
    "businessunit" = "sales"
  }

  instance_description = "VM instance created from instance template"
  machine_type         = "e2-medium"
  can_ip_forward       = true

  # Startup script
  metadata_startup_script = file("./startup.sh")

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  // Using default VPC
  network_interface {
    network = "default"
    access_config {
    }
  }

  # Allow HTTP traffic
  tags = [ "http-server" ]

}

resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
#   region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}