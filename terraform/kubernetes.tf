resource "digitalocean_kubernetes_cluster" "minotar_k8s" {
  name    = "minotar-k8s"
  region  = var.minotar_digitalocean_region
  version = "1.21.2-do.2"

  node_pool {
    name       = "minotar-pool"
    size       = "s-2vcpu-4gb"
    node_count = 2

    tags = [digitalocean_tag.minotar_prod.id]
  }
}

resource "digitalocean_firewall" "minotar_k8s_vpc" {
  name = "vpc-k8s-prod"

  tags = [digitalocean_tag.minotar_prod.id]

  // HTTP from Cloudflare
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.cidr_blocks
  }

  // HTTPS from Cloudflare
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.cidr_blocks
  }

  // Federated Prometheus
  inbound_rule {
    protocol         = "tcp"
    port_range       = "30090"
    source_tags = [digitalocean_tag.monitoring_nodes.id]
  }

  // HTTP from Internal
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["104.131.163.148/32"]
    source_tags = [digitalocean_tag.monitoring_nodes.id]
  }

  // HTTPS from Internal
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["104.131.163.148/32"]
    source_tags = [digitalocean_tag.monitoring_nodes.id]
  }
}
