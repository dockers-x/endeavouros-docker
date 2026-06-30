#!/usr/bin/env bash
set -euxo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/packages.sh"

printf '\n%s\n%s\n' "${archlinuxcn_repo[@]}" >> /etc/pacman.conf

pacman-key --init
pacman-key --populate archlinux
pacman -Syu --noconfirm --needed "${archlinux_keyring_packages[@]}"
pacman -S --noconfirm --needed "${base_packages[@]}"

useradd --create-home --shell /bin/bash builder
printf '%s\n' "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
chmod 0440 /etc/sudoers.d/builder
sudo -u builder paru -S --noconfirm --needed --skipreview "${aur_packages[@]}"
rm -f /etc/sudoers.d/builder
userdel -r builder

usermod --shell /usr/bin/fish root
useradd -D --shell /usr/bin/fish
rm -rf /var/cache/pacman/pkg/*
