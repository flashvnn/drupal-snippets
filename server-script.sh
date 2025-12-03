#!/bin/bash

# ==========================================
# Server Setup Helper Script
# Supports: Virtualmin (LAMP/LEMP), Docker, Portainer, Webmin Fix, SSH Config, PHP Versions
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

add_webmin_referer() {
    echo -e "${BLUE}=== Add Trusted Referrer to Webmin ===${NC}"
    
    # Check if Webmin config exists
    if [ ! -f "/etc/webmin/config" ]; then
        echo -e "${RED}Error: Webmin configuration file not found at /etc/webmin/config.${NC}"
        echo "Is Webmin installed?"
        return
    fi

    # Input domain
    read -p "Enter the domain/hostname to trust (e.g., myserver.com): " referer_domain

    if [ -z "$referer_domain" ]; then
        echo -e "${RED}Error: No domain entered.${NC}"
        return
    fi

    # Backup config
    cp /etc/webmin/config /etc/webmin/config.bak.$(date +%s)
    echo "Backup of config created."

    # Check if referers line exists
    if grep -q "^referers=" /etc/webmin/config; then
        # Check if domain is already present to avoid duplicates
        if grep -q "$referer_domain" /etc/webmin/config; then
             echo -e "${YELLOW}Domain appears to already be in trusted referrers.${NC}"
        else
             # Append to existing line (adding a space before the new domain)
             sed -i "/^referers=/ s/$/ $referer_domain/" /etc/webmin/config
             echo -e "${GREEN}Appended $referer_domain to existing referers.${NC}"
        fi
    else
        # Add new line if key doesn't exist
        echo "referers=$referer_domain" >> /etc/webmin/config
        echo -e "${GREEN}Added 'referers=$referer_domain' to configuration.${NC}"
    fi

    # Restart Webmin
    echo "Restarting Webmin service..."
    if systemctl restart webmin; then
        echo -e "${GREEN}Webmin restarted successfully. Setup complete.${NC}"
    else
        echo -e "${RED}Failed to restart Webmin. Please check service status.${NC}"
    fi
}

configure_ssh_root() {
    echo -e "${BLUE}=== Configuring SSH (Allow Root Login & Password Auth) ===${NC}"
    CONFIG_FILE="/etc/ssh/sshd_config"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Error: SSH config file not found at $CONFIG_FILE${NC}"
        return
    fi

    # Backup config
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak.$(date +%s)"
    echo "Backup of sshd_config created."

    # Update PermitRootLogin
    # Check for both commented and uncommented lines
    if grep -qE "^#?PermitRootLogin" "$CONFIG_FILE"; then
        sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' "$CONFIG_FILE"
        echo "Updated PermitRootLogin to 'yes'."
    else
        echo "PermitRootLogin yes" >> "$CONFIG_FILE"
        echo "Added PermitRootLogin 'yes'."
    fi

    # Update PasswordAuthentication
    if grep -qE "^#?PasswordAuthentication" "$CONFIG_FILE"; then
        sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' "$CONFIG_FILE"
        echo "Updated PasswordAuthentication to 'yes'."
    else
        echo "PasswordAuthentication yes" >> "$CONFIG_FILE"
        echo "Added PasswordAuthentication 'yes'."
    fi

    # Restart SSH service
    echo "Restarting SSH service..."
    if systemctl restart sshd; then
        echo -e "${GREEN}SSH service restarted successfully.${NC}"
    elif systemctl restart ssh; then
        # Fallback for systems using 'ssh' instead of 'sshd' service name
        echo -e "${GREEN}SSH service restarted successfully.${NC}"
    else
        echo -e "${RED}Failed to restart SSH service. Please check manually.${NC}"
    fi
}

install_additional_php() {
    echo -e "${BLUE}=== Install Additional PHP Version ===${NC}"
    
    # Check OS
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo -e "${RED}Cannot detect OS. This function requires Ubuntu or Debian.${NC}"
        return
    fi

    read -p "Enter PHP version to install (e.g., 7.4, 8.0, 8.1, 8.2): " php_ver

    if [[ -z "$php_ver" ]]; then
        echo -e "${RED}Error: No version specified.${NC}"
        return
    fi
    
    echo -e "${YELLOW}Detected OS: $OS${NC}"
    echo "Preparing repositories..."

    if [[ "$OS" == "ubuntu" ]]; then
        # Add PPA for Ubuntu
        if ! command -v add-apt-repository &> /dev/null; then
            apt-get install -y software-properties-common
        fi
        
        # Check if PPA is already added to avoid duplication
        if ! grep -r "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/ &> /dev/null; then
             add-apt-repository -y ppa:ondrej/php
        else
             echo "PPA ondrej/php appears to be already installed. Skipping addition."
        fi
        
        apt-get update
    elif [[ "$OS" == "debian" ]]; then
        # Add Repository for Debian (sury.org)
        # Note: This uses '>' to overwrite the file, preventing duplication on re-runs
        apt-get install -y lsb-release ca-certificates curl
        curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
        sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
        apt-get update
    else
        echo -e "${RED}Unsupported OS for this automated PHP installer. Supports Ubuntu or Debian only.${NC}"
        return
    fi

    echo "Installing PHP $php_ver and extensions for WordPress/Drupal..."
    # Installing CLI, FPM, CGI (needed for Virtualmin), and common extensions
    # Added: imagick (WP image processing), opcache (performance), apcu (caching), exif (WP requirement)
    apt-get install -y "php$php_ver" "php$php_ver-cli" "php$php_ver-fpm" "php$php_ver-cgi" \
                       "php$php_ver-mysql" "php$php_ver-zip" "php$php_ver-gd" "php$php_ver-xml" \
                       "php$php_ver-mbstring" "php$php_ver-curl" "php$php_ver-soap" "php$php_ver-intl" \
                       "php$php_ver-bcmath" "php$php_ver-imagick" "php$php_ver-opcache" "php$php_ver-apcu" \
                       "php$php_ver-exif"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}PHP $php_ver installed successfully.${NC}"
        echo "If using Virtualmin, navigate to 'System Settings' -> 'Re-Check Configuration' to detect the new PHP version."
    else
        echo -e "${RED}Installation failed. Please check if PHP version $php_ver exists in the repository.${NC}"
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
    echo "5. Fix Webmin 'Trusted Referrer' Warning"
    echo "6. Configure SSH (Allow Root & Password)"
    echo "7. Install Additional PHP Version"
    echo "8. Exit"
    echo -e "${BLUE}========================================${NC}"
    read -p "Select an option [1-8]: " choice

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
            add_webmin_referer
            wait_for_user
            ;;
        6)
            configure_ssh_root
            wait_for_user
            ;;
        7)
            install_additional_php
            wait_for_user
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
