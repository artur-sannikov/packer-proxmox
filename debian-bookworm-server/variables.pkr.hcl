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
variable "proxmox_node" {
  type = string
}
variable "proxmox_vm_id" {
  type    = string
  default = "100"
}
variable "proxmox_disk_size" {
  type = string
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
