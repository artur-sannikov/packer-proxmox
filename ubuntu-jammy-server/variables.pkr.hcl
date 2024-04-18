# Connect to Proxmox
variable "proxmox_api_url" {
    type = string
}
variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}
variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Upload ISO
variable "iso" {
    description = "Download Ubuntu ISO and verify checksum"
    type = object({
        url = string
        checksum = string
    })
}

# VM configuration
variable "vm" {
  description = "Configuration options for VM"
  type = object({
    node = string
    id   = number
    disk_size = string
  })
}

# SSH credentials for Packer
variable "ssh_private_key_file" {
    type = string
    sensitive = true
}
variable "ssh_username" {
    type = string
}

variable "http" {
    description = "HTTP server IP and port(s) for autoinstall"
    type = object({
        bind_address = string
        port_min = number
        port_max = number
    })
}
