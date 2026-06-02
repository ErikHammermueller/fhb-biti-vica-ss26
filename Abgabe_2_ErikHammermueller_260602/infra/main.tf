# Ubuntu Template suchen
data "exoscale_template" "ubuntu" {
  zone = "at-vie-1"
  name = "Linux Ubuntu 24.04 LTS 64-bit"
}

# SSH Key registrieren
resource "exoscale_ssh_key" "erik" {
  name       = "erik-key-2"
  public_key = var.ssh_public_key
}

# Firewall
resource "exoscale_security_group" "web" {
  name = "erik-abgabe2-sg"
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.web.id

  type        = "INGRESS"
  protocol    = "TCP"
  start_port  = 22
  end_port    = 22
  cidr        = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.web.id

  type        = "INGRESS"
  protocol    = "TCP"
  start_port  = 80
  end_port    = 80
  cidr        = "0.0.0.0/0"
}

# VM
resource "exoscale_compute_instance" "vm" {

  zone = "at-vie-1"

  name = "erik-abgabe2"

  template_id = data.exoscale_template.ubuntu.id

  type = "standard.micro"

  disk_size = 10

  ssh_keys = [
    exoscale_ssh_key.erik.name
  ]

  security_group_ids = [
    exoscale_security_group.web.id
  ]

  user_data = file("${path.module}/cloud-init.yaml")
}