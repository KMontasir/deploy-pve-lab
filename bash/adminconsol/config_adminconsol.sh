#!/bin/bash

# Charger les variables externes
source ./variables.sh

#######################################
# Installation des dépendances
#######################################
apt update && apt upgrade -y
apt install -y gnupg software-properties-common wget sudo

#######################################
# Installation de Terraform
#######################################
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt upgrade -y
apt-get install -y terraform

#######################################
# Installation d'Ansible
#######################################
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" \
    | gpg --dearmor -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" \
    | tee /etc/apt/sources.list.d/ansible.list
apt update && apt upgrade -y
apt install -y ansible

#######################################
# Création des utilisateurs et config SSH
#######################################
for user in "${users[@]}"; do
    echo "Configuration de l'utilisateur : $user"

    useradd -m -s /bin/bash "$user"
    usermod -aG sudo "$user"
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers > /dev/null

    mkdir -p /home/$user/.ssh/
    cat $ssh_pub_key_value > /home/$user/.ssh/authorized_keys
    cat $ssh_pub_key_value > /home/$user/.ssh/$ssh_pub_key_name
    cat $ssh_priv_key_value > /home/$user/.ssh/$ssh_priv_key_name
    chown -R $user:$user /home/$user/
    chmod 700 /home/$user/.ssh
    chmod 600 /home/$user/.ssh/*
done

#######################################
# Configuration IP statique
#######################################
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $interface_name
iface $interface_name inet static
    address $static_ip
    gateway $gateway_ip
    dns-nameservers $dns_server
EOF
echo "nameserver $dns_server" > /etc/resolv.conf

#######################################
# Changement du nom d'hôte
#######################################
echo "$new_hostname" > /etc/hostname
hostnamectl set-hostname "$new_hostname"
sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/" /etc/hosts || echo "127.0.1.1   $new_hostname" >> /etc/hosts
