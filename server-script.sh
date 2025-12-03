#!/bin/bash

# ==========================================
# Server Setup Helper Script
# Supports: Virtualmin (LAMP/LEMP), Docker, Portainer
# ==========================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root.${NC}"
   echo "Please run with sudo or as root user."
   exit 1
fi

# ==========================================
# Functions
# ==========================================

wait_for_user() {
    echo ""
    echo -e "${YELLOW}Press Enter to return to the menu...${NC}"
    read -r
}

install_virtualmin_lamp() {
    echo -e "${BLUE}=== Installing Virtualmin (LAMP Stack) ===${NC}"
    echo "Downloading installer..."
    
    # Download the script
    wget https://software.virtualmin.com/gpl/scripts/install.sh -O virtualmin-install.sh
    
    if [ -f "virtualmin-install.sh" ]; then
        chmod +x virtualmin-install.sh
        echo -e "${GREEN}Installer downloaded. Starting installation...${NC}"
        # Run default installation (LAMP is default)
        /bin/sh virtualmin-install.sh
        
        # Cleanup
        rm virtualmin-install.sh
    else
        echo -e "${RED}Failed to download Virtualmin installer.${NC}"
    fi
}

install_virtualmin_lemp() {
    echo -e "${BLUE}=== Installing Virtualmin (LEMP Stack) ===${NC}"
    echo "Downloading installer..."
    
    wget https://software.virtualmin.com/gpl/scripts/install.sh -O virtualmin-install.sh
    
    if [ -f "virtualmin-install.sh" ]; then
        chmod +x virtualmin-install.sh
        echo -e "${GREEN}Installer downloaded. Starting installation with --bundle LEMP...${NC}"
        # Run installation with LEMP bundle
        /bin/sh virtualmin-install.sh --bundle LEMP
        
        # Cleanup
        rm virtualmin-install.sh
    else
        echo -e "${RED}Failed to download Virtualmin installer.${NC}"
    fi
}

install_docker() {
    echo -e "${BLUE}=== Installing Docker ===${NC}"
    
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker is already installed.${NC}"
        docker --version
    else
        echo "Downloading and running official Docker install script..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
        
        echo -e "${GREEN}Docker installation complete.${NC}"
        systemctl enable docker
        systemctl start docker
    fi
}

install_portainer() {
    echo -e "${BLUE}=== Installing Portainer CE ===${NC}"
    
    # Check dependency
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is not installed.${NC}"
        echo "Please install Docker first (Option 3)."
        return
    fi

    # Create Volume
    echo "Creating Docker volume 'portainer_data'..."
    docker volume create portainer_data

    # Check if container already exists
    if [ "$(docker ps -aq -f name=portainer)" ]; then
        echo -e "${YELLOW}A container named 'portainer' already exists.${NC}"
        echo "Removing old container..."
        docker rm -f portainer
    fi

    echo "Pulling and running Portainer..."
    # Standard install command for Portainer CE (Community Edition)
    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Portainer installed successfully!${NC}"
        echo -e "Access it via HTTPS at: https://<your-server-ip>:9443"
    else
        echo -e "${RED}Portainer failed to start.${NC}"
    fi
}

# ==========================================
# Main Menu Loop
# ==========================================

while true; do
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "   Server Helper Script"
    echo -e "${BLUE}========================================${NC}"
    echo "1. Install Virtualmin (LAMP - Apache/MySQL)"
    echo "2. Install Virtualmin (LEMP - Nginx/MySQL)"
    echo "3. Install Docker (Official Script)"
    echo "4. Install Portainer (Docker Management)"
    echo "5. Exit"
    echo -e "${BLUE}========================================${NC}"
    read -p "Select an option [1-5]: " choice

    case $choice in
        1)
            install_virtualmin_lamp
            wait_for_user
            ;;
        2)
            install_virtualmin_lemp
            wait_for_user
            ;;
        3)
            install_docker
            wait_for_user
            ;;
        4)
            install_portainer
            wait_for_user
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
