build {

  name    = "coreos-39"
  sources = ["source.proxmox-iso.coreos"]

  provisioner "shell" {
    inline = [
      "sudo rm /etc/ssh/ssh_host_*", # Remove SSH host keys to prevent reuse in clones
      "sudo truncate -s 0 /etc/machine-id", # Reset machine id
    ]
  }
}