#!/bin/bash

# Fonction - Configuration de la console d'administration
config_adminconsol() {
    # Configuration de la console d'administration
    echo -e "${BLUE}Configuration de la console d'administration...${RESET}"
    cd "$SCRIPT_DIR/bash/adminconsol/"
    ./config_adminconsol.sh
    echo -e "${GREEN}La configuration de la console d'administration est terminée${RESET}"
    echo -e "${BLUE}[INFORMATION]: La machine va redémarrer dans 10 secondes pour prendre en compte les changements...${RESET}"
    echo -e "${BLUE}Pour annuler le redémarrage --> CTRL+C${RESET}"
    sleep 10
    reboot
}

# Fonction - Configuration du serveur Proxmox Virtual Environment
config_pve() {
    # Configuration du serveur Proxmox Virtual Environment
    echo -e "${BLUE}Configuration du serveur Proxmox Virtual Environment...${RESET}"
    cd "$SCRIPT_DIR/bash/proxmox_ve/"
    ./config_pve.sh
    echo -e "${GREEN}La configuration du serveur Proxmox Virtual Environment est terminée${RESET}"
    echo -e "${BLUE}[INFORMATION]: Redémarrer le serveur Proxmox VE pour prendre en compte les changements...${RESET}"
    
    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}

# Fonction - Déploiement d'OPNsense
deploy_router() {
    # Clonage de la VM via le programme Terraform
    echo -e "${BLUE}Clonage de la VM via le programme Terraform...${RESET}"
    cd "$SCRIPT_DIR/terraform/clone-opnsense/"
    terraform init -upgrade
    terraform apply
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de base de la VM via Ansible
    echo -e "${BLUE}Configuration de base de la VM via Ansible...${RESET}"
    cd "$SCRIPT_DIR/ansible/"
    ansible-playbook -i inventory.yml configure-opnsense.yml -e "vars_file=./vars/variables_opnsense.yml"
    echo -e "${GREEN}Le déploiement de la VM OPNsense est terminé${RESET}"

    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}

# Fonction - Déploiement de Debian
deploy_debian() {
    # Clonage de la VM via le programme Terraform
    echo -e "${BLUE}Clonage de la VM via le programme Terraform...${RESET}"
    cd "$SCRIPT_DIR/terraform/clone-debian/"
    terraform init -upgrade
    terraform apply
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de base de la VM via Ansible
    echo -e "${BLUE}Configuration de base de la VM via Ansible...${RESET}"
    cd "$SCRIPT_DIR/ansible/"
    ansible-playbook -i inventory.yml configure-debian.yml -e "vars_file=./vars/variables_debian.yml"
    echo -e "${GREEN}Le déploiement de la VM est terminé${RESET}"

    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}

# Fonction - Déploiement de Wazuh
deploy_edr() {
    # Clonage de la VM via le programme Terraform
    echo -e "${BLUE}Clonage de la VM via le programme Terraform...${RESET}"
    cd "$SCRIPT_DIR/terraform/clone-debian/"
    terraform init -upgrade
    terraform apply
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de base de la VM via Ansible
    echo -e "${BLUE}Configuration de base de la VM via Ansible...${RESET}"
    cd "$SCRIPT_DIR/ansible/"
    ansible-playbook -i inventory.yml configure-debian.yml -e "vars_file=./vars/variables_edr.yml"
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30
    
    # Configuration de Wazuh via Ansible
    echo -e "${BLUE}Configuration de Wazuh via Ansible...${RESET}"
    ansible-playbook -i inventory.yml install-wazuh.yml
    echo -e "${GREEN}Le déploiement de la VM Wazuh est terminé${RESET}"

    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}

# Fonction - Déploiement de Prometheus et Grafana
deploy_monitoring() {
    # Clonage de la VM via le programme Terraform
    echo -e "${BLUE}Clonage de la VM via le programme Terraform...${RESET}"
    cd "$SCRIPT_DIR/terraform/clone-debian/"
    terraform init -upgrade
    terraform apply
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de base de la VM via Ansible
    echo -e "${BLUE}Configuration de base de la VM via Ansible...${RESET}"
    cd "$SCRIPT_DIR/ansible/"
    ansible-playbook -i inventory.yml configure-debian.yml -e "vars_file=./vars/variables_monitoring.yml"
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de Prometheus et Grafana via Ansible
    echo -e "${BLUE}Configuration de Prometheus et Grafana via Ansible...${RESET}"
    ansible-playbook -i inventory.yml install-prometheus-grafana.yml
    echo -e "${GREEN}Le déploiement de la VM Prometheus/Grafana est terminé${RESET}"

    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}

# Fonction - Déploiement de Squid
deploy_proxy() {
    # Clonage de la VM via le programme Terraform
    echo -e "${BLUE}Clonage de la VM via le programme Terraform...${RESET}"
    cd "$SCRIPT_DIR/terraform/clone-debian/"
    terraform init -upgrade
    terraform apply
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30

    # Configuration de base de la VM via Ansible
    echo -e "${BLUE}Configuration de base de la VM via Ansible...${RESET}"
    cd "$SCRIPT_DIR/ansible/"
    ansible-playbook -i inventory.yml configure-debian.yml -e "vars_file=./vars/variables_proxy.yml"
    echo -e "${BLUE}Pause de 30 secondes. Attente du redémarrage de la machine...${RESET}"
    sleep 30
    
    # Configuration de Squid
    echo -e "${BLUE}Configuration de Squid via Ansible...${RESET}"
    ansible-playbook -i inventory.yml install-squid.yml
    echo -e "${GREEN}Le déploiement de la VM Squid est terminé${RESET}"

    # Replacement dans le répertoire racine du programme
    cd "$SCRIPT_DIR"
}
