#!/bin/bash

set -e  # Quitter en cas d'erreur
set -o pipefail  # Capturer les erreurs dans les pipelines

# Mise à jour du cache de paquet
sudo apt-get update  

# Désinstaller les anciens paquets Docker, s'ils existent
echo "Suppression des anciens paquets Docker..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    if dpkg -l | grep -q $pkg; then
        sudo apt-get remove -y $pkg || {
            echo "Erreur lors de la suppression de $pkg. Arrêt du script."
            exit 1
        }
    fi
done

# Mettre à jour les sources de paquets et installer les dépendances
echo "Mise à jour des sources de paquets et installation des dépendances..."
sudo apt-get update || { echo "Erreur lors de la mise à jour des sources de paquets. Arrêt du script."; exit 1; }
sudo apt-get install -y ca-certificates curl || { echo "Erreur lors de l'installation des dépendances. Arrêt du script."; exit 1; }

# Créer le répertoire pour la clé GPG de Docker
echo "Création du répertoire pour la clé GPG de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings || { echo "Erreur lors de la création du répertoire /etc/apt/keyrings. Arrêt du script."; exit 1; }

# Télécharger la clé GPG officielle de Docker
echo "Téléchargement de la clé GPG officielle de Docker..."
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc || { echo "Erreur lors du téléchargement de la clé GPG. Arrêt du script."; exit 1; }
sudo chmod a+r /etc/apt/keyrings/docker.asc || { echo "Erreur lors de la modification des permissions de la clé GPG. Arrêt du script."; exit 1; }

# Ajouter le dépôt Docker aux sources d'Apt
echo "Ajout du dépôt Docker aux sources d'Apt..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Erreur lors de l'ajout du dépôt Docker. Arrêt du script."; exit 1; }

# Mettre à jour les sources de paquets
echo "Mise à jour des sources de paquets après ajout du dépôt Docker..."
sudo apt-get update || { echo "Erreur lors de la mise à jour des sources de paquets après ajout du dépôt Docker. Arrêt du script."; exit 1; }

# Installer Docker
echo "Installation de Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { echo "Erreur lors de l'installation de Docker. Arrêt du script."; exit 1; }

# Vérifier l'installation en exécutant le conteneur hello-world
echo "Vérification de l'installation de Docker en exécutant le conteneur hello-world..."
sudo docker run hello-world || { echo "Erreur lors de l'exécution du conteneur hello-world. Arrêt du script."; exit 1; }

echo "Installation de Docker terminée avec succès."
