#!/bin/bash

# Define variables
COMPOSER_DIR="$HOME/.local/bin"
COMPOSER_PATH="$COMPOSER_DIR/composer"
INSTALLER_PATH="composer-setup.php"

# Create the Composer directory if it doesn't exist
mkdir -p $COMPOSER_DIR

# Download the Composer installer script
php -r "copy('https://getcomposer.org/installer', '$INSTALLER_PATH');"

# Verify the installer SHA-384 to ensure it is not corrupted
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('SHA384', '$INSTALLER_PATH') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('$INSTALLER_PATH'); exit(1); } echo PHP_EOL;"

# Run the installer script
php $INSTALLER_PATH --install-dir=$COMPOSER_DIR --filename=composer

# Remove the installer script
php -r "unlink('$INSTALLER_PATH');"

# Ensure the install directory is in the PATH
if ! grep -q "$COMPOSER_DIR" <<< "$PATH"; then
    echo "export PATH=\"$COMPOSER_DIR:\$PATH\"" >> ~/.bashrc
    source ~/.bashrc
fi

# Verify the installation
composer -V

echo "Composer installed successfully in $COMPOSER_DIR"
