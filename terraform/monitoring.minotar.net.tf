resource "digitalocean_droplet" "monitoring" {
  image              = "ubuntu-20-04-x64"
  name               = "monitoring.cluster.minotar.net"
  region             = var.minotar_digitalocean_region
  size               = "s-1vcpu-1gb"
  ipv6               = true
  private_networking = true
  // These keys won't allow root logins as they are disabled in cloud-init
  // (but they do prevent a root password being set)
  ssh_keys = [
    data.digitalocean_ssh_key.lukeh_1.id,
    data.digitalocean_ssh_key.lukeh_2.id,
    data.digitalocean_ssh_key.lukeh_3.id,
    data.digitalocean_ssh_key.lukes_1.id,
  ]
  tags      = [digitalocean_tag.monitoring_nodes.id]
  user_data = data.template_file.user_data.rendered
}

resource "digitalocean_firewall" "minotar_monitoring_public" {
  name = "public-monitoring"

  tags = [digitalocean_tag.monitoring_nodes.id]

  // INBOUND

  // SSH / HTTP / HTTPS
  dynamic "inbound_rule" {
    for_each = toset([
      "22",
      "80",
      "443",
    ])
    content {
      protocol         = "tcp"
      port_range       = inbound_rule.value
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }

  // ICMP Ping
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  // OUTBOUND

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
