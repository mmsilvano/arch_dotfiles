#!/bin/bash

echo -e "\033[0;36m[INFO]\033[0m Setting up pnpm & Node tools..."

if command -v pnpm &>/dev/null; then
    echo -e "\033[0;32m[OK]\033[0m pnpm already available: $(pnpm --version)"
else
    echo -e "\033[0;36m[INFO]\033[0m Enabling corepack for pnpm..."
    corepack enable
    corepack prepare pnpm@latest --activate
    echo -e "\033[0;32m[OK]\033[0m pnpm installed."
fi

# Install global tools
echo -e "\033[0;36m[INFO]\033[0m Installing global npm tools..."
sudo npm install -g \
    neovim \
    intelephense \
    @shufo/blade-formatter \
    prettier \
    typescript \
    typescript-language-server \
    2>/dev/null || echo -e "\033[1;33m[WARN]\033[0m Some npm tools failed (non-fatal)"

echo -e "\033[0;32m[OK]\033[0m Node tools setup complete."
