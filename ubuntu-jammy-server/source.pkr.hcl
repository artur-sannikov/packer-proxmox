source "proxmox-iso" "ubuntu-jammy-srv" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"
  # Skip TLS Verification
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "${var.vm.node}"
  vm_id                = "${var.vm.id}"
  vm_name              = "ubuntu-jammy-srv"
  template_description = "Ubuntu Jammy Server Image"

  # VM OS Settings
  iso_url          = "${var.iso.url}"
  iso_checksum     = "${var.iso.checksum}"
  iso_storage_pool = "local"
  unmount_iso      = true

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-single"

  disks {
    type         = "virtio"
    storage_pool = "local-zfs"
    disk_size    = "${var.vm.disk_size}"
    io_thread    = true
    discard      = true
  }

  # VM CPU Settings
  cores    = "1"
  cpu_type = "host"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"

  # PACKER Boot Commands
  boot_command = [
    "<wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---",
    "<wait>",
    "<f10><wait>"
  ]
  boot      = "c"
  boot_wait = "5s"

  # PACKER Autoinstall Settings
  http_directory = "http"
  # (Optional) Bind IP Address and Port
  http_bind_address = "${var.http.bind_address}"
  http_port_min     = "${var.http.port_min}"
  http_port_max     = "${var.http.port_max}"

  # SSH access for Packer
  ssh_username         = var.ssh_username
  ssh_private_key_file = "${var.ssh_private_key_file}"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "20m"
}