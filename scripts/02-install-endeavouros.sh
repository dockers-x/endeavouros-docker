#!/usr/bin/env bash
set -euxo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/packages.sh"

curl -fsSL https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/master/endeavouros-mirrorlist/endeavouros-mirrorlist \
    -o /etc/pacman.d/endeavouros-mirrorlist

printf '\n%s\n%s\n%s\n' \
    "[endeavouros]" \
    "SigLevel = PackageRequired" \
    "Include = /etc/pacman.d/endeavouros-mirrorlist" \
    >> /etc/pacman.conf

touch /etc/lsb-release

for key in "${endeavouros_keys[@]}"; do
    pacman-key --recv-key "$key" --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key "$key"
done

pacman -Sy --noconfirm --needed "${endeavouros_packages[@]}"
rm -rf /var/cache/pacman/pkg/*
