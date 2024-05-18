# Packer files to build Proxmox VM templates

## Preparation

1. Create a `credentials.pkrvars.hcl` file with the following content:

```
proxmox_api_url          = ""  # Proxmox IP Address
proxmox_api_token_id     = "packer@pve!packer"                    # API Token ID (Proxmox user)
proxmox_api_token_secret = "" # Proxmox API Token
```
Keep it secret!

2. Create a `packer` user with restricted permissions. The easiest way is by SSHing into Proxmox and running these commands:

```bash
pveum useradd packer@pve # Add user
pveum role add Packer -privs "Datastore.AllocateTemplate VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use VM.Config.Cloudinit" # Add Packer role with restricted permissions
pveum aclmod / -user packer@pve -role Packer # Add packer user to Packer role
```

3. Adjust firewall rules on your network to allow Proxmox access your workstation, i.e., the HTTP server that Packer spins up to serve configuration files. I manually set up the IP address and port in Packer variables:

```
http = {
  bind_address =
  port_min     =
  port_max     =
}
```
## How do I create a template?

Enter the directory of interest and run `./run-packer.sh validate` to validate the configuration, and then `./run-packer.sh build` to start the building process.

## Variables

I tend to have a limited number of variables to keep things simple. My systems do not change often, and most settings are kept identical across templates. However, it should be easy with this structure to add more variables to serve your needs. All possible variables are available in the Proxmox Packer integration [docs](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso).

If I need to increase memory or the number of CPU cores, it's easier to do on Proxmox.

### Common

```hcl
# Settings for VM
vm = {
  node =
  id =
  disk_size =
}

# Download ISO and verify checksum
iso = {
  url      =
  checksum = ""
}

# HTTP server IP and ports for preseed.cfg
http = {
  bind_address =
  port_min     =
  port_max     =
}
```

### Unique

I use an SSH password to set up a Debian template and SSH key pairs for Ubuntu and CoreOS.

## Resources

1. [CoreOS template on Proxmox with Packer](https://wirywolf.com/2022/12/coreos-template-on-proxmox-with-packer), Amey Parulekar
2. [Create VMs on Proxmox in Seconds!](https://youtu.be/1nf3WOEFq1Y), Christian Lempa
3. [Ubuntu Server 22.04 image with Packer and Subiquity for Proxmox](https://www.aerialls.eu/posts/ubuntu-server-2204-image-packer-subiquity-for-proxmox/), Julien Brochet
4. [Cloud-init docs](https://cloudinit.readthedocs.io/en/latest/index.html)
5. [All preseed options](https://preseed.debian.net/debian-preseed/), Steve McIntyre
6. [Automating the installation using preseeding](https://www.debian.org/releases/stable/amd64/apb.en.html)
7. [Ignition configuration docs for Fedora CoreOS](https://coreos.github.io/ignition/)
