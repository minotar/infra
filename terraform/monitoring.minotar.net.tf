resource "digitalocean_droplet" "monitoring" {
  image              = "ubuntu-20-04-x64"
  name               = "monitoring.minotar.net"
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
