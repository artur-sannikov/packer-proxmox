# Build Definition to create the VM Template
build {
  name    = "fedora-40-srv"
  sources = ["source.proxmox-iso.fedora-40-srv"]

  # From Christian Lempa
  # Thank you!
  # https://github.com/ChristianLempa/boilerplates/blob/main/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl
  provisioner "shell" {
    inline = [
      "rm /etc/ssh/ssh_host_*",        # Remove ssh host keys to prevent reuse in clones
      "truncate -s 0 /etc/machine-id", # Reset machine id so that clone generates its own
      "dnf -y autoremove",
      "dnf clean -y all",
      "cloud-init clean",
      "sync"
    ]
  }
}
