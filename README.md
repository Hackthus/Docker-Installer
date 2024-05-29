# Script d'Installation de Docker Engine sur Debian

Ce dépôt contient un script bash pour installer Docker sur un système Debian. Le script supprime les anciennes versions de Docker, ajoute le dépôt officiel de Docker, et installe les paquets nécessaires. 

## Prérequis

Pour installer Docker Engine, vous avez besoin de la version 64 bits de l'un de ces Debian versions:

Debian Bookworm 12 (stable)
Debian Bullseye 11 (ancien)

- Accès superutilisateur (sudo)

## Instructions d'Installation

### 1. Télécharger le script

Clonez ce dépôt ou téléchargez le script directement :

 
git clone https://github.com/Hackthus/Docker-Installer.git

cd Docker-Installer

chmod +x installer-docker-engine.sh
sudo ./installer-docker-engine.sh

