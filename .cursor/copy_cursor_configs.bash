#!/bin/bash

copy_cursor_configs() {
  local config_dir="$HOME/.cursor/"
  local destination_dir=""
  
  # Determine OS and set the appropriate config directory
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    destination_dir="$HOME/Library/Application Support/Cursor/User"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    destination_dir="$HOME/.config/Cursor/User"
  else
    echo "Unsupported operating system: $OSTYPE"
    return 1
  fi
  
  # Check if destination directory exists, create if not
  if [[ ! -d "$config_dir" ]]; then
    mkdir -p "$config_dir"
    echo "Created destination directory: $config_dir"
  fi
  
  # Check if source directory exists
  if [[ ! -d "$destination_dir" ]]; then
    echo "Cursor configuration directory not found: $destination_dir"
    return 1
  fi
  
  # Copy settings.json if it exists
  if [[ -f "$destination_dir/settings.json" ]]; then
    cp "$destination_dir/settings.json" "$config_dir/"
    echo "Copied settings.json to $config_dir/"
  else
    echo "settings.json not found in $destination_dir/"
  fi
  
  # Copy keybindings.json if it exists
  if [[ -f "$destination_dir/keybindings.json" ]]; then
    cp "$destination_dir/keybindings.json" "$config_dir/"
    echo "Copied keybindings.json to $config_dir/"
  else
    echo "keybindings.json not found in $destination_dir/"
  fi
  
  echo "Cursor configuration files copied successfully."
}

copy_cursor_configs
