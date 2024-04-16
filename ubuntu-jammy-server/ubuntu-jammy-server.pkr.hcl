# Ubuntu Jammy Server

# Packer Template to create an Ubuntu Server (Jammy) on Proxmox

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-jammy-srv" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "${var.proxmox_node}"
    vm_id = "${var.virtual_environment.vm_id}"
    vm_name = "ubuntu-jammy-srv"
    template_description = "Ubuntu Jammy Server Image"

    # VM OS Settings
    iso_url = "${var.iso.url}"
    iso_checksum = "${var.iso.checksum}"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-single"

    disks {
        type = "virtio"
        storage_pool = "${var.virtual_environment.disk_storage_pool}"
        disk_size = "${var.virtual_environment.disk_size}"
        io_thread = true
        discard = true
    }

    # VM CPU Settings
    cores = "1"
    cpu_type = "host"
    
    # VM Memory Settings
    memory = "2048" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
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
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    # (Optional) Bind IP Address and Port
    http_bind_address = "${var.http.bind_address}"
    http_port_min = "${var.http.port_min}"
    http_port_max = "${var.http.port_max}"

    # SSH access for Packer
    ssh_username = var.ssh_username
    ssh_private_key_file = "${var.ssh_private_key_file}"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-jammy"
    sources = ["source.proxmox-iso.ubuntu-jammy-srv"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*", # Remove ssh host keys to prevent reuse in clones
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
}
