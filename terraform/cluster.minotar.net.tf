resource "digitalocean_domain" "net_minotar_cluster" {
  name       = "cluster.minotar.net"
}

resource "digitalocean_record" "net_minotar_cluster_monitoring_A" {
  for_each = toset([
    "monitoring",
    "auth",
    "prometheus.monitoring",
    "grafana.monitoring",
  ])

  domain = digitalocean_domain.net_minotar_cluster.name
  type   = "A"
  name   = each.value
  value  = digitalocean_droplet.monitoring.ipv4_address
  ttl    = 3600
}

resource "digitalocean_record" "net_minotar_cluster_monitoring_AAAA" {
  for_each = toset([
    "monitoring",
    "auth",
    "prometheus.monitoring",
    "grafana.monitoring",
  ])

  domain = digitalocean_domain.net_minotar_cluster.name
  type   = "AAAA"
  name   = each.value
  value  = digitalocean_droplet.monitoring.ipv6_address
  ttl    = 3600
}
