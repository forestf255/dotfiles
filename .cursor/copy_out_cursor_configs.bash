#!/bin/bash

copy_cursor_configs() {
  local config_dir="$HOME/.cursor"
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
  if [[ ! -d "$destination_dir" ]]; then
    mkdir -p "$destination_dir"
    echo "Created destination directory: $destination_dir"
  fi
  
  # Check if source directory exists
  if [[ ! -d "$config_dir" ]]; then
    echo "Cursor configuration directory not found: $config_dir"
    return 1
  fi
  
  # Copy settings.json if it exists
  if [[ -f "$config_dir/settings.json" ]]; then
    cp "$config_dir/"settings.json "$destination_dir/settings.json"
    echo "Copied settings.json to $destination_dir/"
  else
    echo "settings.json not found in $config_dir/"
  fi
  
  # Copy keybindings.json if it exists
  if [[ -f "$config_dir/keybindings.json" ]]; then
    cp "$config_dir/keybindings.json" "$destination_dir/keybindings.json"
    echo "Copied keybindings.json to $destination_dir/"
  else
    echo "keybindings.json not found in $config_dir/"
  fi
  
  echo "Cursor configuration files copied successfully."
}

copy_cursor_configs
