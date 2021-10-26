data "template_file" "user_data" {
  template = file("./cloud-init.yaml")

  vars = {
    lukeh_ssh_1 = data.digitalocean_ssh_key.lukeh_1.public_key
    lukeh_ssh_2 = data.digitalocean_ssh_key.lukeh_2.public_key
    lukeh_ssh_3 = data.digitalocean_ssh_key.lukeh_3.public_key
    lukes_ssh_1 = data.digitalocean_ssh_key.lukes_1.public_key
  }
}
