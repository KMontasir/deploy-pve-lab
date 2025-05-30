#!/bin/bash

# Charger les autres fichiers
source ./variables.sh
source ./functions/setup_repositories.sh
source ./functions/setup_appliance.sh
source ./functions/setup_storage.sh
source ./functions/setup_users.sh
source ./functions/setup_network.sh

# Fonction pour afficher un titre
print_title() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}== $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Fonction principale
main() {
    print_title "Début de la configuration"
    
    echo -e "${YELLOW}-> Configuration des dépôts...${NC}"
    setup_repositories && echo -e "${GREEN}Dépôts configurés avec succès.${NC}" || echo -e "${RED}Erreur lors de la configuration des dépôts.${NC}"

    echo -e "${YELLOW}-> Configuration de l'appliance...${NC}"
    setup_appliance && echo -e "${GREEN}Appliance configurée avec succès.${NC}" || echo -e "${RED}Erreur lors de la configuration de l'appliance.${NC}"

    echo -e "${YELLOW}-> Configuration du stockage...${NC}"
    setup_storage && echo -e "${GREEN}Stockage configuré avec succès.${NC}" || echo -e "${RED}Erreur lors de la configuration du stockage.${NC}"

    echo -e "${YELLOW}-> Configuration des utilisateurs...${NC}"
    setup_users && echo -e "${GREEN}Utilisateurs configurés avec succès.${NC}" || echo -e "${RED}Erreur lors de la configuration des utilisateurs.${NC}"

    echo -e "${YELLOW}-> Configuration du réseau...${NC}"
    setup_network && echo -e "${GREEN}Réseau configuré avec succès.${NC}" || echo -e "${RED}Erreur lors de la configuration du réseau.${NC}"
}

# Appel de la fonction principale
main
