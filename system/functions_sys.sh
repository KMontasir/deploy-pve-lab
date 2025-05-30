#!/bin/bash

# Banière principale
banner_title() {
    echo -e "${RED}                               ##                         ## "
    echo -e "${RED}                               ## "
    echo -e "${RED}  ##  ##    ####    #####     #####    ####     #####    ###     ###### "
    echo -e "${RED}  #######  ##  ##   ##  ##     ##         ##   ##         ##      ##  ## "
    echo -e "${RED}  ## # ##  ##  ##   ##  ##     ##      #####    #####     ##      ## "
    echo -e "${RED}  ##   ##  ##  ##   ##  ##     ## ##  ##  ##        ##    ##      ## "
    echo -e "${RED}  ##   ##   ####    ##  ##      ###    #####   ######    ####    #### "
    echo ""
}

# Banière "Au revoir"
banner_goodbye() {
	banner_title
	echo ""
	echo -e "${BLUE} Au revoir!${RESET}"
	echo ""
	exit 0
}

# Menu principal
menu_principal() {
	while true; do
	
		# Afficher la banière principale
		banner_title
	
		# Afficher le menu principal
		echo -e "${BLUE}             ====================================${RESET}"
		echo -e "${BLUE}             ========== MENU PRINCIPAL ==========${RESET}"
		echo -e "${BLUE}             ====================================${RESET}"
		echo ""
        echo -e "${YELLOW}           1.  Configurer la Console d'administration${RESET}" 
        echo -e "${YELLOW}           2.  Configurer le serveur Proxmox Virtual Environment${RESET}" 
        echo -e "${YELLOW}           3.  Créer/Configurer les templates - (en développement)${RESET}" 
        echo -e "${YELLOW}           4.  Créer une VM OPNsense (Routeur/Pare-Feu) - (en développement)${RESET}"
		echo -e "${YELLOW}           5.  Créer une VM Debian (Distribution Linux)${RESET}" 
		echo -e "${YELLOW}           6.  Créer une VM Wazuh (EDR)${RESET}"
		echo -e "${YELLOW}           7.  Créer une VM Prometheus et Grafana (Monitoring)${RESET}"
        echo -e "${YELLOW}           8.  Créer une VM Squid (Proxy)${RESET}"
        echo -e "${YELLOW}           ?.  Obtenir de l'aide${RESET}"
		echo -e "${RED}           0. Quitter${RESET}"
		echo ""
	
		# Demander à l'utilisateur de choisir une option
		read -p "Veuillez sélectionner une option (0-8) : " choice

        # Lancement des functions (Dans '$SCRIPT_DIR/system/functions_deployment.sh' et '$SCRIPT_DIR/system/functions_sys.sh')
		case $choice in
			1) config_adminconsol ;;
            2) config_pve ;;
            3) deploy_template ;;
            4) deploy_router ;;
            5) deploy_debian ;;
			6) deploy_edr ;;
			7) deploy_monitoring ;;
            8) deploy_proxy ;;
            9) get_help ;;
			0) banner_goodbye ;;
			*) echo -e "${RED}Option non valide. Veuillez entrer un nombre valide.${RESET}" ;;
		esac
	done
}
