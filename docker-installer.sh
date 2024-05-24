#!/bin/bash

# Fonction pour vérifier si Docker est déjà installé
check_docker_installed() {
    if [ -x "$(command -v docker)" ]; then
        echo "Docker est déjà installé."
        return 0
    else
        echo "Docker n'est pas installé."
        return 1
    fi
}

# Fonction pour installer Docker
install_docker() {
    echo "Installation de Docker..."
    if ! curl -fsSL https://get.docker.com -o get-docker.sh; then
        echo "Erreur lors du téléchargement du script d'installation de Docker."
        exit 1
    fi
    if ! sudo sh get-docker.sh; then
        echo "Erreur lors de l'installation de Docker."
        exit 1
    fi
    if ! sudo usermod -aG docker $USER; then
        echo "Erreur lors de l'ajout de l'utilisateur au groupe Docker."
        exit 1
    fi
    sudo rm get-docker.sh
    echo "Docker installé avec succès."
}

# Fonction pour installer Docker Compose
install_docker_compose() {
    echo "Installation de Docker Compose..."
    if ! sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; then
        echo "Erreur lors du téléchargement de Docker Compose."
        exit 1
    fi
    if ! sudo chmod +x /usr/local/bin/docker-compose; then
        echo "Erreur lors du changement des permissions pour Docker Compose."
        exit 1
    fi
    echo "Docker Compose installé avec succès."
}

# Fonction pour vérifier la version de Docker
check_docker_version() {
    echo "Version Docker installée :"
    docker --version
}

# Fonction pour vérifier la version de Docker Compose
check_docker_compose_version() {
    echo "Version Docker Compose installée :"
    docker-compose --version
}

# Vérifier si Docker est déjà installé
if check_docker_installed; then
    # Installer Docker Compose
    install_docker_compose
else
    # Installer Docker et Docker Compose
    install_docker
    install_docker_compose
fi

# Vérifier les versions installées
check_docker_version
check_docker_compose_version
