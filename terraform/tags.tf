
resource "digitalocean_tag" "monitoring_nodes" {
  name = "monitoring"
  lifecycle {
    prevent_destroy = false
  }
}

