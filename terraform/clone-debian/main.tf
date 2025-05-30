resource "proxmox_vm_qemu" "clone_vm" {
  name        = var.vm_name
  target_node = var.target_node
  vmid        = var.vm_id

  clone       = var.template_name
  full_clone  = var.full_clone

  cores       = var.cores
  memory      = var.memory

  disk {
    slot     = var.disk_slot
    size     = var.disk_size
    type     = var.disk_type
    storage  = var.disk_storage
    format   = var.disk_format
  }

  network {
    model  = var.net_model
    bridge = var.net_bridge
  }

  agent = var.enable_agent
}
