#!/bin/bash

setup_users() {
    echo -e "${YELLOW}Création des utilisateurs Linux avec accès web Proxmox (sans token API)...${NC}"

    declare -A USERS
    for entry in $LINUX_USERS; do
        key="${entry%%:*}"
        value="${entry#*:}"
        USERS[$key]=$value
    done

    for user in "${!USERS[@]}"; do
        password=${USERS[$user]}
        proxmox_user="${user}@pam"

        echo -e "${YELLOW}Création utilisateur Linux : $user${NC}"
        if id "$user" &>/dev/null; then
            echo -e "${GREEN}L'utilisateur $user existe déjà, mise à jour du mot de passe.${NC}"
        else
            useradd -m -s /bin/bash "$user" || { echo -e "${RED}Erreur création utilisateur $user.${NC}"; continue; }
        fi

        echo "$user:$password" | chpasswd || { echo -e "${RED}Erreur mise à jour mot de passe $user.${NC}"; continue; }
        usermod -aG sudo "$user"
        echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$user"
        chmod 440 "/etc/sudoers.d/$user"

        mkdir -p "/home/$user/.ssh"
        touch "/home/$user/.ssh/authorized_keys"
        chown -R "$user:$user" "/home/$user"
        chmod 700 "/home/$user/.ssh"
        chmod 600 "/home/$user/.ssh/authorized_keys"

        echo -e "${YELLOW}Ajout utilisateur Proxmox : $proxmox_user${NC}"
        pveum user add "$proxmox_user" --comment "Utilisateur Linux $user via PAM" 2>/dev/null || echo -e "${GREEN}Utilisateur Proxmox $proxmox_user déjà existant.${NC}"
        pveum acl modify / --users "$proxmox_user" --roles Administrator

        echo -e "${GREEN}Utilisateur $user configuré avec accès web (pas de token API).${NC}"
    done

    echo -e "${YELLOW}Création des utilisateurs Proxmox pour automatisation (avec token API)...${NC}"

    for user in $AUTO_USERS; do
        echo -e "${YELLOW}Ajout utilisateur Proxmox automatisation : $user${NC}"
        pveum user add "$user" --comment "Utilisateur automation sans Linux" 2>/dev/null || echo -e "${GREEN}Utilisateur Proxmox $user déjà existant.${NC}"
        pveum acl modify / --users "$user" --roles Administrator

        TOKEN_NAME="automation_token"
        echo -e "${YELLOW}Création token API pour $user${NC}"
        TOKEN_OUTPUT=$(pveum user token add "$user" "$TOKEN_NAME" --privsep 1 2>&1)
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Erreur création token API pour $user : $TOKEN_OUTPUT${NC}"
        else
            {
                echo "=== $user ==="
                echo "Token name : $TOKEN_NAME"
                echo "$TOKEN_OUTPUT"
                echo ""
            } >> /tmp/proxmox_tokens.log
            echo -e "${GREEN}Utilisateur $user configuré pour automatisation.${NC}"
        fi
    done

    echo -e "${GREEN}Configuration terminée. Tokens enregistrés dans /tmp/proxmox_tokens.log${NC}"
}
