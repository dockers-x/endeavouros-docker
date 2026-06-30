#!/usr/bin/env bash

archlinuxcn_repo=(
    "[archlinuxcn]"
    "Server = https://repo.archlinuxcn.org/\$arch"
)

archlinux_keyring_packages=(
    archlinux-keyring
    archlinuxcn-keyring
)

base_packages=(
    base-devel
    ca-certificates
    curl
    fastfetch
    fish
    git
    paru
    starship
    sudo
)

aur_packages=(
    herdr-bin
)

endeavouros_keys=(
    0F20FADC599D1C46EB556455AED8858E4B9813F1
    497AF50C92AD2384C56E1ACA003DB8B0CB23504F
)

endeavouros_packages=(
    endeavouros-keyring
    endeavouros-mirrorlist
    endeavouros-theming
    eos-hooks
)
