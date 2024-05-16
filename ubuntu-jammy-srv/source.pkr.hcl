# Resource definition for the VM Template
source "proxmox-iso" "ubuntu-jammy-srv" {

  # Proxmox connection settings
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret
  # Skip TLS verification
  insecure_skip_tls_verify = true

  # VM general settings
  node                 = var.vm.node
  vm_id                = var.vm.id
  vm_name              = "ubuntu-jammy-srv"
  template_description = "Ubuntu Jammy Server Image"

  # VM ISO
  iso_url          = var.iso.url
  iso_checksum     = var.iso.checksum
  iso_storage_pool = "local"
  unmount_iso      = true

  # Enable VM QEMU agent option
  qemu_agent = true

  # VM hard disk
  scsi_controller = "virtio-scsi-single"
  disks {
    type         = "virtio"
    storage_pool = "local-zfs"
    disk_size    = var.vm.disk_size
    format       = "raw"
    io_thread    = true
    discard      = true
  }

  # VM CPU
  cores    = "1"
  cpu_type = "host"

  # VM memory
  memory = 2048

  # VM network
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  # VM cloud-init
  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"

  # Packer boot commands
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

  # Packer autoinstall settings
  http_directory    = "http"
  http_bind_address = var.http.bind_address
  http_port_min     = var.http.port_min
  http_port_max     = var.http.port_max

  # SSH settings for Packer
  ssh_username         = var.ssh_username
  ssh_private_key_file = var.ssh_private_key_file

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
}
