#!/bin/bash

# Variables stockage
DISK="/dev/sda"
PARTITION="${DISK}3"

# Liste des utilisateurs Linux avec leur mot de passe (avec accès web Proxmox)
LINUX_USERS="alice:PassAlice123 bob:PassBob123 charlie:PassCharlie123"

# Liste des utilisateurs d'automatisation Proxmox (sans compte Linux)
AUTO_USERS="auto1@pveauto auto2@pveauto auto3@pveauto"

# Nom d'hôte
HOSTNAME="pve"

# Variables réseau
WAN_INTERFACE="ensp01"
WAN_IP="192.168.20.79"
WAN_NETMASK="255.255.255.0"
WAN_GATEWAY="192.168.20.254"
WAN_DOMAIN="domaine.local"

# Liste des URLs d'ISO à télécharger
ISO_URLS=(
  "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
)

# ----------------------------------------- #
# !!! Modifier uniquement si nécessaire !!! #
# ----------------------------------------- #
# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# fichier de configuration du nom d'hôte
HOSTS_FILE="/etc/hosts"

# fichier de configuration du réseau
CONFIG_FILE="/etc/network/interfaces"

# Configuration du stockage
VG_NAME="pve"
LV_NAME="root"
STORAGE_CFG="/etc/pve/storage.cfg"

# Répertoire cible (Proxmox ISO default)
ISO_DIR="/var/lib/vz/template/iso"
