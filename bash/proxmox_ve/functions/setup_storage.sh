#!/bin/bash

setup_storage() {
    echo -e "${YELLOW}=== Extension de ${PARTITION}, suppression de local-lvm et allocation de l'espace à local ===${NC}"

    echo -e "${YELLOW}Configuration du volume local...${NC}"
    pvesm set local --content images,iso,rootdir,vztmpl,backup,snippets
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erreur lors de la configuration du volume local.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Suppression du volume local-lvm...${NC}"
    pvesm remove local-lvm
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erreur lors de la suppression de local-lvm.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Vérification du volume LVM 'data'...${NC}"
    if lvdisplay | grep -q "/dev/${VG_NAME}/data"; then
        echo -e "${YELLOW}[INFO] Suppression du volume LVM 'data'...${NC}"
        lvremove -f "${VG_NAME}/data"
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}[ERROR] Échec de la suppression du volume LVM 'data'.${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}[INFO] Le volume 'data' n'existe pas, rien à supprimer.${NC}"
    fi

    echo -e "${YELLOW}[INFO] Extension de ${PARTITION}...${NC}"
    parted "${DISK}" resizepart 3 100% || {
        echo -e "${RED}[ERROR] Échec de l'extension de ${PARTITION}.${NC}"
        return 1
    }
    partprobe

    echo -e "${YELLOW}[INFO] Redimensionnement du PV LVM sur ${PARTITION}...${NC}"
    pvresize "${PARTITION}" || {
        echo -e "${RED}[ERROR] Échec du redimensionnement du PV.${NC}"
        return 1
    }

    FREE_SPACE=$(vgdisplay "${VG_NAME}" | awk '/Free  PE/ {print $5}')
    if [[ "$FREE_SPACE" -gt 0 ]]; then
        echo -e "${YELLOW}[INFO] Ajout de l'espace libre au volume ${LV_NAME}...${NC}"
        lvextend -l +100%FREE "/dev/${VG_NAME}/${LV_NAME}" || {
            echo -e "${RED}[ERROR] Échec de l'extension du volume logique.${NC}"
            return 1
        }
        resize2fs "/dev/${VG_NAME}/${LV_NAME}" || {
            echo -e "${RED}[ERROR] Échec du redimensionnement du système de fichiers.${NC}"
            return 1
        }
        echo -e "${GREEN}[SUCCESS] Espace ajouté à la partition ${LV_NAME}.${NC}"
    else
        echo -e "${YELLOW}[WARNING] Aucun espace libre disponible dans le VG '${VG_NAME}'.${NC}"
    fi

    systemctl restart pvedaemon
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}[ERROR] Échec du redémarrage de pvedaemon.${NC}"
        return 1
    fi

    echo -e "${GREEN}=== Opération terminée ! ===${NC}"
    df -h
}
