# Variables for Proxmox host
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
variable "proxmox_node" {
    type = string
}

# Variables for downloading ISO and checksum
variable "iso" {
    description = "ISO URL and checksum"
    type = object({
        url = string
        checksum = string
    })
}

variable "ssh_private_key_file" {
    type = string
    sensitive = true
}

# Variables for setting up virual environment
variable "virtual_environment" {
    type = object({
        vm_id = number
        disk_storage_pool = string
        disk_size = string
        cloud_init_storage_pool = string
    })
}

variable "http" {
    description = "HTTP server IP and port(s)"
    type = object({
        bind_address = string
        port_min = number
        port_max = number
    })
}
