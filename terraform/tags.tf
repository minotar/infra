
resource "digitalocean_tag" "monitoring_nodes" {
  name = "monitoring"
  lifecycle {
    prevent_destroy = false
  }
}

resource "digitalocean_tag" "minotar_prod" {
  name = "k8s-prod"
}
