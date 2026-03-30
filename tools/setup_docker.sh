#!/bin/bash

echo -e "\033[0;36m[INFO]\033[0m Configuring Docker..."

echo -e "\033[0;36m[INFO]\033[0m Enabling Docker daemon..."
sudo systemctl enable --now docker

echo -e "\033[0;36m[INFO]\033[0m Adding $USER to docker group..."
sudo usermod -aG docker "$USER"

echo -e "\033[0;32m[OK]\033[0m Docker configured. Logout/Login required."
