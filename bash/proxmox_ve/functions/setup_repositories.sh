#!/bin/bash

# Fonction pour configurer les dépôts
setup_repositories() {
    echo -e "${YELLOW}Suppression des fichiers de dépôt d'entreprise Proxmox et de ceph-quincy...${NC}"
    rm -f /etc/apt/sources.list.d/pve-enterprise.list \
          /etc/apt/sources.list.d/ceph-quincy.list

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Fichiers supprimés avec succès.${NC}"
    else
        echo -e "${RED}Erreur lors de la suppression des fichiers.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Nettoyage des références problématiques...${NC}"
    sed -i '/enterprise.proxmox.com/d' /etc/apt/sources.list

    # Vérifier si des fichiers .list existent avant de lancer sed
    for f in /etc/apt/sources.list.d/*.list; do
        [[ -e "$f" ]] && sed -i '/ceph-quincy/d' "$f"
    done
    echo -e "${GREEN}Références nettoyées.${NC}"

    echo -e "${YELLOW}Activation des dépôts non commerciaux de Proxmox...${NC}"
    echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

    echo -e "${YELLOW}Mise à jour des dépôts...${NC}"
    apt clean -y
    apt update -y
    apt upgrade -y
    apt autoremove -y

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Mise à jour terminée avec succès.${NC}"
    else
        echo -e "${RED}Erreur lors de la mise à jour des paquets.${NC}"
        return 1
    fi
}
