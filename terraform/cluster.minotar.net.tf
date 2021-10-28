resource "digitalocean_domain" "net_minotar_cluster" {
  name       = "cluster.minotar.net"
}

resource "digitalocean_record" "net_minotar_cluster_monitoring" {
  for_each = tomap({
    "A" = digitalocean_droplet.monitoring.ipv4_address,
    "AAAA" = digitalocean_droplet.monitoring.ipv6_address,
  })

  domain = digitalocean_domain.net_minotar_cluster.name
  type   = each.key
  name   = "monitoring"
  value  = each.value
  ttl    = 3600
}
