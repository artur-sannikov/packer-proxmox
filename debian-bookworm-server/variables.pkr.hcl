# Connect to Proxmox
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}
variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

# Upload ISO
variable "iso" {
  description = "Download Debian ISO and verify checksum"
  type = object({
    url      = string
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

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "http" {
  description = "HTTP server IP and port(s) for preseed.cfg"
  type = object({
    bind_address = string
    port_min     = number
    port_max     = number
  })
}
