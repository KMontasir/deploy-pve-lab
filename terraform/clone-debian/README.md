# Terraform - Clonage de VM sur Proxmox

Ce projet Terraform permet de cloner une VM existante (template) sur un serveur Proxmox VE, avec possibilité de personnaliser :

- le nom de la VM
- les ressources (CPU, RAM, disque)
- le stockage
- la configuration réseau

Ce projet ne supporte pas encore Cloud-Init (clonage de VMs classiques uniquement).

---

## Structure du projet

.
├── main.tf              # Création de la VM clonée (n'est pas à modifier)
├── provider.tf          # Connexion à l'API Proxmox (possible de modifier : 'source', 'version' et 'pm_tls_insecure')
├── variables.tf         # Déclaration des variables (n'est pas à modifier)
├── terraform.tfvars     # Fichier de configuration principal (contient les variables et leurs valeurs modifiables)
└── README.md            # Documentation du projet

---

## Prérequis

- Terraform ≥ 1.0 (https://www.terraform.io/downloads)
- Provider Terraform non-officiel : telmate/proxmox (https://registry.terraform.io/providers/Telmate/proxmox/latest)
- Un template Proxmox déjà prêt (non-cloud-init)
- Un token API Proxmox avec les permissions nécessaires
- Clé SSH déjà présente dans le template si besoin d’accès distant

---

## Utilisation

### 1. Initialiser le projet
```bash
terraform init
```

### 2. Vérifier la configuration
```bash
terraform plan
```

### 3. Appliquer les changements
```bash
terraform apply
```

---

## Personnalisation

Tu peux modifier tous les paramètres via le fichier terraform.tfvars :

# Exemple : définir le nom, l’ID et le nœud cible
```bash
vm_name      = "vm-dev-001"
vm_id        = 105
target_node  = "pve-node1"
```

# Exemple : ressources
```bash
cores        = 2
memory       = 4096
```

# Exemple : disque
```bash
disk_size    = "50G"
disk_type    = "scsi"
disk_storage = "local-lvm"
```

Tous les champs sont obligatoires. Aucune valeur par défaut n’est définie dans le code Terraform.

---

## Exemple de commande multi-env

Tu peux utiliser plusieurs environnements (dev, prod, etc.) :
```bash
terraform apply -var-file="environments/dev.tfvars"
```

---

## Sécurité

- Ne versionne jamais ton terraform.tfvars contenant un token ou des secrets.
- Utilise un .gitignore pour éviter d’ajouter des fichiers sensibles.

Exemple .gitignore :
```bash
terraform.tfstate
terraform.tfvars
.terraform/
```

---

## Références

- Documentation Proxmox API : https://pve.proxmox.com/pve-docs/api-viewer/index.html
- Provider Terraform Proxmox (Telmate) : https://registry.terraform.io/providers/Telmate/proxmox/latest

---

## À venir (suggestions)

- Support Cloud-Init
- Provisioning via SSH (remote-exec)
- Génération automatique de VMID
- Modules réutilisables

---

## Aide

Si tu veux aller plus loin ou automatiser autre chose, n'hésite pas à me demander ici.
