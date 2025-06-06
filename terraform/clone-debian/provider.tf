# Déclaration du provider Proxmox (non officiel : telmate/proxmox)

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"  # Adapte si tu veux figer une version
    }
  }
}

# Configuration du provider Proxmox
provider "proxmox" {
  pm_api_url           = var.pm_api_url
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret  = var.pm_api_token_secret
  pm_tls_insecure      = true                       # À désactiver en prod si SSL OK
}
