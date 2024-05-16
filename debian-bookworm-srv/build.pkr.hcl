# Build definition to create the VM template
build {
  name    = "debian-bookworm-srv"
  sources = ["source.proxmox-iso.debian-bookworm-srv"]

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }
  # From Christian Lempa
  # Thank you!
  # https://github.com/ChristianLempa/boilerplates/blob/main/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl
  provisioner "shell" {
    inline = [
      "sudo rm /etc/ssh/ssh_host_*",                 # Remove ssh host keys to prevent reuse in clones
      "sudo truncate -s 0 /etc/machine-id",          # Reset machine id so that clone generates its own
      "sudo truncate -s 0 /var/lib/dbus/machine-id", # machine id reset specific to Debian
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo sync"
    ]
  }
}
