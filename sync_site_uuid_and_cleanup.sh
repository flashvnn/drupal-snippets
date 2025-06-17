#!/bin/bash

# Default config folder
CONFIG_FOLDER=${1:-"./config"}

# Path to system.site.yml
SITE_YML="$CONFIG_FOLDER/system.site.yml"

# Check if file exists
if [ ! -f "$SITE_YML" ]; then
  echo "❌ Error: system.site.yml not found in $CONFIG_FOLDER"
  exit 1
fi

# Extract UUID from system.site.yml
UUID=$(grep '^uuid:' "$SITE_YML" | awk '{print $2}')

# Check if UUID is found
if [ -z "$UUID" ]; then
  echo "❌ Error: UUID not found in $SITE_YML"
  exit 1
fi

echo "✅ Found UUID: $UUID"

# Update UUID using drush
echo "🔄 Updating site UUID..."
drush cset system.site uuid "$UUID" -y

if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to update site UUID."
  exit 1
fi

echo "✅ Site UUID updated successfully."

# Delete all shortcuts
echo "🗑️  Deleting all shortcut entities..."
drush ev "\Drupal::entityTypeManager()->getStorage('shortcut')->delete(\Drupal::entityTypeManager()->getStorage('shortcut')->loadMultiple());"
drush ev "\Drupal::entityTypeManager()->getStorage('shortcut_set')->delete(\Drupal::entityTypeManager()->getStorage('shortcut_set')->loadMultiple());"

if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to delete shortcuts."
  exit 1
fi

echo "✅ All shortcuts deleted successfully."

# Optionally run config import
echo "🚀 Importing configuration..."
drush cim -y

if [ $? -eq 0 ]; then
  echo "🎉 Configuration imported successfully!"
else
  echo "❌ Error: Configuration import failed."
  exit 1
fi
