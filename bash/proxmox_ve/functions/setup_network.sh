#!/bin/bash

# Installation et configuration d'Open vSwitch
setup_network() {
    echo -e "${YELLOW}Création des groupes de ressources...${NC}"
    for pool in template testing functional; do
        pveum pool add "$pool"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}Groupe $pool créé avec succès.${NC}"
        else
            echo -e "${RED}Erreur lors de la création du groupe $pool.${NC}"
            return 1
        fi
    done

    echo -e "${YELLOW}Génération de la nouvelle configuration réseau...${NC}"

    cat <<EOF > "$CONFIG_FILE"
# Configuration réseau avec Open vSwitch

# Boucle locale
auto lo
iface lo inet loopback

# Interface WAN ---------------------------
auto $WAN_INTERFACE
iface $WAN_INTERFACE inet manual
	ovs_type OVSPort
	ovs_bridge vmbr0

# Bridge vmbr0 pour interface WAN
auto vmbr0
iface vmbr0 inet static
    address $WAN_IP
    netmask $WAN_NETMASK
    gateway $WAN_GATEWAY
    ovs_type OVSBridge
    ovs_ports $WAN_INTERFACE

# Bridge vmbr1 pour VLANs 10 et 20 -------------------------
auto vmbr1
iface vmbr1 inet manual
    ovs_type OVSBridge
    ovs_ports vlan10 vlan20

# VLAN 10 sur vmbr1
auto vlan10
iface vlan10 inet manual
    ovs_type OVSIntPort
    ovs_bridge vmbr1
    ovs_options tag=10

# VLAN 20 sur vmbr1
auto vlan20
iface vlan20 inet manual
    ovs_type OVSIntPort
    ovs_bridge vmbr1
    ovs_options tag=20

EOF

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Configuration réseau écrite dans $CONFIG_FILE.${NC}"
    else
        echo -e "${RED}Erreur lors de l’écriture de la configuration réseau.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Ajout des entrées de Management WAN et LAN...${NC}"
    {
        echo "127.0.0.1 localhost"
        echo "$WAN_IP $HOSTNAME"
    } > "$HOSTS_FILE"

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Fichier hosts mis à jour.${NC}"
    else
        echo -e "${RED}Erreur lors de la mise à jour du fichier hosts.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Redémarrage des services réseau...${NC}"
    systemctl restart openvswitch-switch
    systemctl restart networking

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Services réseau redémarrés avec succès.${NC}"
    else
        echo -e "${RED}Erreur lors du redémarrage des services réseau.${NC}"
        return 1
    fi

    echo -e "${GREEN}Configuration Open vSwitch terminée.${NC}"
}
