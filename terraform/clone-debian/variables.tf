# Connexion API Proxmox
variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

# VM à cloner
variable "template_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "target_node" {
  type = string
}

variable "full_clone" {
  type = bool
}

# Ressources
variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

# Disque
variable "disk_size" {
  type = string
}

variable "disk_slot" {
  type = number
}

variable "disk_type" {
  type = string
}

variable "disk_storage" {
  type = string
}

variable "disk_format" {
  type = string
}

# Réseau
variable "net_model" {
  type = string
}

variable "net_bridge" {
  type = string
}

# Agent invité
variable "enable_agent" {
  type = number
}
