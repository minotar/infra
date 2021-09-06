resource "digitalocean_kubernetes_cluster" "minotar_k8s" {
  name    = "minotar-k8s"
  region  = var.minotar_digitalocean_region
  version = "1.21.2-do.2"

  node_pool {
    name       = "minotar-pool"
    size       = "s-2vcpu-4gb"
    node_count = 2
  }
}
