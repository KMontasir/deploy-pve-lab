# variables.sh

# Changement du nom d'hôte
new_hostname="console-admin"

# Liste des utilisateurs à créer
users=("admin-console" "admin-devops" "admin-netops")

# Nom de code Ubuntu/Debian
UBUNTU_CODENAME=jammy

# Variables réseau
static_ip="192.168.1.100/24"
gateway_ip="192.168.1.254"
dns_server="192.168.1.254"
interface_name="ens33"

# Variables SSH
ssh_pub_key_name="id_ed0001.pub"
ssh_pub_key_value="VOTRE CLÉ PUBLIQUE ICI"
ssh_priv_key_name="id_ed0001"
ssh_priv_key_value="-----BEGIN OPENSSH PRIVATE KEY-----
VOTRE
CLÉ
PRIVÉE
ICI=
-----END OPENSSH PRIVATE KEY-----
"
