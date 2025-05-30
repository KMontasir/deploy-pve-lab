# === Connexion Proxmox ===

# URL de l'API Proxmox (ne pas oublier /api2/json à la fin)
pm_api_url = "https://proxmox.local:8006/api2/json"

# Token d'accès (format : user@realm!token)
pm_api_token_id = "terraform@pve!tf-token"

# Clé secrète du token (ne jamais partager publiquement)
pm_api_token_secret = "xxxxxxxxxxxxxxxxxxxxxxxx"


# === VM clonée ===

# Nom de la nouvelle VM à créer
vm_name = "web-server-01"

# ID unique de la VM (doit être libre sur le cluster)
vm_id = 101

# Nœud Proxmox sur lequel créer la VM
target_node = "pve-node1"

# Template Proxmox source (doit exister sur le même nœud)
template_name = "ubuntu-22.04-template"

# true = copie indépendante, false = dépend du template
full_clone = true


# === Configuration matérielle ===

# Nombre de CPU virtuels
cores = 2

# Quantité de mémoire vive en MB (2048 = 2Go)
memory = 2048


# === Disque principal ===

# Taille du disque (ex: "30G")
disk_size = "30G"

# Slot utilisé pour le disque (souvent 0)
disk_slot = 0

# Type de disque : "scsi", "virtio", etc.
disk_type = "scsi"

# Nom du stockage Proxmox (ex: "local-lvm")
disk_storage = "local-lvm"

# Format du disque (raw ou qcow2)
disk_format = "raw"


# === Réseau ===

# Modèle de carte réseau (virtio est recommandé)
net_model = "virtio"

# Bridge réseau Proxmox (souvent vmbr0)
net_bridge = "vmbr0"


# === QEMU Guest Agent ===

# Activer QEMU Guest Agent (1 = oui, 0 = non)
enable_agent = 1
