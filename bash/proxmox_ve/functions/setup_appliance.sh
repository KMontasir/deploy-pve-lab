#!/bin/bash

# Fonction pour installer et configurer OpenSSH, Sudo et Open vSwitch
setup_appliance() {
    echo -e "${YELLOW}Mise à jour des paquets...${NC}"
    apt update && apt upgrade -y
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Mise à jour terminée.${NC}"
    else
        echo -e "${RED}Erreur lors de la mise à jour.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Configuration d'OpenSSH...${NC}"
    sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
    sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's|^#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2|' /etc/ssh/sshd_config

    systemctl restart sshd
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}OpenSSH configuré et redémarré avec succès.${NC}"
    else
        echo -e "${RED}Erreur lors du redémarrage d'OpenSSH.${NC}"
        return 1
    fi

    # Fonction d'installation conditionnelle
    install_if_missing() {
        local pkg=$1
        if ! dpkg -l | grep -qw "$pkg"; then
            echo -e "${YELLOW}Installation de $pkg...${NC}"
            apt install -y "$pkg"
            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}$pkg installé avec succès.${NC}"
            else
                echo -e "${RED}Erreur lors de l'installation de $pkg.${NC}"
                return 1
            fi
        else
            echo -e "${GREEN}$pkg est déjà installé.${NC}"
        fi
    }

    install_if_missing parted || return 1
    install_if_missing sudo || return 1
    install_if_missing openvswitch-switch || return 1

    echo -e "${YELLOW}Téléchargement des ISO...${NC}"
    for url in "${ISO_URLS[@]}"; do
        filename=$(basename "$url")
        fullpath="$ISO_DIR/$filename"

        if [ -f "$fullpath" ]; then
            echo -e "${GREEN}ISO déjà présent : $filename — ignoré.${NC}"
        else
            echo -e "${YELLOW}Téléchargement de : $filename${NC}"
            wget -q --show-progress -O "$fullpath" "$url"
            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}Téléchargement de $filename réussi.${NC}"
            else
                echo -e "${RED}Erreur lors du téléchargement de $filename.${NC}"
                return 1
            fi
        fi
    done

    echo -e "${GREEN}Configuration de l'appliance terminée.${NC}"
}
