# Resource Definiation for the VM Template
source "proxmox-iso" "fedora-39-srv" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"
  # Skip TLS Verification
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "${var.proxmox_node}"
  vm_id                = "${var.proxmox_vm_id}"
  vm_name              = "fedora-39-srv"
  template_description = "Fedora 39 Server Image"

  # VM OS Settings
  iso_file         = "${var.proxmox_iso_file}"
  iso_checksum     = "${var.proxmox_iso_checksum}"
  iso_storage_pool = "local"
  unmount_iso      = true

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-single"

  disks {
    disk_size    = "${var.proxmox_disk_size}"
    format       = "raw"
    storage_pool = "local-lvm"
    type         = "virtio"
    io_thread    = true
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
  cloud_init_storage_pool = "local-lvm"

  # Packer Boot Commands
  boot_command = [
    "<up><tab> ip=dhcp inst.cmdline inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
    ]

  # PACKER Autoinstall Settings
  http_directory = "http"
  # (Optional) Bind IP Address and Port
  # http_bind_address = "0.0.0.0"
  # http_port_min = 8802
  # http_port_max = 8802

  ssh_username = "root"

  # SSH password
  ssh_password = "packer"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
}
