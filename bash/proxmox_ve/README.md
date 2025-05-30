# Script d'Installation et Configuration Proxmox

Ce projet contient un ensemble de scripts bash permettant d’automatiser la configuration initiale d’un serveur Proxmox, incluant la configuration des dépôts, de l’appliance, du stockage, des utilisateurs et du réseau (avec Open vSwitch).

---

## Table des matières

- [Présentation](#présentation)  
- [Prérequis](#prérequis)  
- [Installation](#installation)  
- [Usage](#usage)  
- [Structure des scripts](#structure-des-scripts)  
- [Variables de configuration](#variables-de-configuration)  
- [Fichiers générés](#fichiers-générés)  
- [Avertissements](#avertissements)  
- [Licence](#licence)

---

## Présentation

Ce script principal `config_pve.sh` orchestre plusieurs scripts modulaires chargés de :  

- Configurer les dépôts Proxmox pour utiliser les dépôts non commerciaux.  
- Mettre à jour et configurer l’appliance Proxmox (SSH, sudo, openvswitch).  
- Configurer le stockage en redimensionnant les volumes LVM et en allouant l’espace libre.  
- Créer les utilisateurs Linux et Proxmox avec les bons droits et générer des tokens API pour l'automatisation.  
- Configurer le réseau avec Open vSwitch, VLANs, et groupes de ressources.  
- Télécharger les ISO nécessaires dans le répertoire Proxmox par défaut.

---

## Prérequis

- Un serveur Proxmox installé et accessible.  
- Accès root ou sudo (pour l'exécution des scripts).  
- Connexion internet pour téléchargement des paquets et ISOs.  
- Les fichiers scripts et le fichier de variables.

---

## Installation

1. Copier tous les scripts (`config_pve.sh`, `variables.sh`, `functions/*.sh`) sur le serveur Proxmox.  
2. Rendre le script principal exécutable :

```bash
chmod +x config_pve.sh
```

3. Lancer le script principal :

```bash
./config_pve.sh
```

---

## Usage

Le script principal lance automatiquement chaque étape, affichant des messages colorés indiquant la progression et les éventuelles erreurs.  

Les étapes exécutées sont :  
- Configuration des dépôts Proxmox.  
- Configuration de l’appliance (OpenSSH, sudo, openvswitch).  
- Configuration du stockage (redimensionnement LVM).  
- Création des utilisateurs Linux et Proxmox, avec génération de tokens API.  
- Configuration réseau avec Open vSwitch et VLANs.

---

## Structure des scripts

| Script                            | Description                                                     |
|---------------------------------- |-----------------------------------------------------------------|
| `config_pve.sh`                   | Script principal orchestrant l’exécution des autres scripts.    |
| `variables.sh`                    | Contient toutes les variables de configuration.                 |
| `functions/setup_repositories.sh` | Configure les dépôts Proxmox non commerciaux.                   |
| `functions/setup_appliance.sh`    | Met à jour le système, configure OpenSSH, sudo et Open vSwitch. |
| `functions/setup_storage.sh`      | Gère la configuration et extension du stockage local.           |
| `functions/setup_users.sh`        | Crée les utilisateurs Linux et Proxmox avec tokens API.         |
| `functions/setup_network.sh`      | Configure les interfaces réseau et VLANs via Open vSwitch.      |


---

## Variables de configuration

Les variables suivantes sont configurables dans `variables.sh` :

| Variable          | Description                                 | Exemple                             |
|------------------ |---------------------------------------------|-------------------------------------|
| `DISK`            | Disque principal pour le stockage           | `/dev/sda`                          |
| `PARTITION`       | Partition à redimensionner                  | `/dev/sda3`                         |
| `LINUX_USERS`     | Liste des utilisateurs Linux + mot de passe | `alice:PassAlice123 bob:PassBob123` |
| `AUTO_USERS`      | Utilisateurs Proxmox pour automatisation    | `auto1@pveauto auto2@pveauto`       |
| `HOSTNAME`        | Nom d’hôte du serveur                       | `pve`                               |
| `WAN_INTERFACE`   | Interface WAN à configurer                  | `ensp01`                            |
| `WAN_IP`          | Adresse IP statique pour WAN                | `192.168.20.79`                     |
| `WAN_NETMASK`     | Masque réseau                               | `255.255.255.0`                     |
| `WAN_GATEWAY`     | Passerelle réseau                           | `192.168.20.254`                    |
| `ISO_URLS`        | URLs des ISOs à télécharger                 | Voir fichier                        |
| `ISO_DIR`         | Répertoire de destination pour ISOs         | `/var/lib/vz/template/iso`          |

---

## Fichiers générés

- `/tmp/proxmox_tokens.log` : Contient les tokens API générés pour les utilisateurs Proxmox.  
- `/etc/network/interfaces` : Configuration réseau écrite par `setup_network.sh`.  
- `/etc/hosts` : Mis à jour avec IP et hostname.  

---

## Avertissements

- Ce script modifie des configurations critiques du système. Sauvegardez vos données et configurations avant exécution.  
- Assurez-vous que les mots de passe des utilisateurs sont sécurisés (Ne pas conserver les mots de passe).  
- Le script supprime certains volumes LVM, assurez-vous de comprendre les impacts.  
- Ce script est conçu pour Debian Bookworm avec Proxmox; adaptation nécessaire pour d’autres distributions.

---

## Licence

Projet open-source, libre à utilisation et modification sous les termes de la licence MIT.
