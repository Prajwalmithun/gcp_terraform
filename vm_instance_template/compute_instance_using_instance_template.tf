resource "google_compute_instance_from_template" "vm_instance" {
    name = "vm-instance-from-template"
    zone = "us-west1-a"
    
    source_instance_template = google_compute_instance_template.instance_template.self_link_unique
}