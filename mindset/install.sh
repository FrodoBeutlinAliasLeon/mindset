#!/bin/bash

# Check for root
# if $EUID equals 0 its a root user. 
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run with sudo"
  exit 1
fi

# Check for curl
if ! command -v curl &> /dev/null; then
  echo "curl not found. Installing..."
  apt install -y curl
fi

# Check for xbindkeys
# &> /dev/null supresses every kind of stdio
if ! command -v xbindkeys &> /dev/null; then
  echo "xbindkeys not found. Intalling..."
  apt update && apt install -y xbindkeys
fi

# pulseaudio-utils (für pactl)
if ! command -v pactl &> /dev/null; then
  echo "pactl not found. Installing pulseaudio-utils..."
  apt install -y pulseaudio-utils
fi


# Check for Rust
# &> /dev/null supresses every kind of stdio
if ! command -v cargo &> /dev/null; then
  echo "Rust not found. Installing..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source $HOME/.cargo/env
fi

# build-essential
if ! dpkg -s build-essential &> /dev/null; then
  echo "build-essential not found. Installing..."
  apt install -y build-essential
fi

# Build the Rust project
echo "Building the rust programm..."
cargo build --release

# Copy Binary
INSTALL_PATH="/usr/local/bin/mindset"
cp target/release/mindset "$INSTALL_PATH"

# Find keycode for F9
KEYCODE=$(xbindkeys -k <<< $'\e[20~' 2>/dev/null | grep "c:" | awk '{print $3}')
[ -z "$KEYCODE" ] && KEYCODE=75  # fallback to 75 (typical F9)

# Write .xbindkeysrc
echo "Configure xbindkeys..."
cat > /home/$SUDO_USER/.xbindkeysrc <<EOF
"$INSTALL_PATH"
    m:0x0 + c:$KEYCODE
EOF

# Start xbindkeys
echo "Starting xbindkeys"
pkill xbindkeys 2>/dev/null
sudo -u "$SUDO_USER" xbindkeys

echo "Everything is ready. Programm will run on F9"
