# Use the Arch Linux base image
FROM archlinux:latest

ENV SHELL=/usr/bin/fish

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Enable archlinuxcn and install base tooling.
RUN set -eux; \
    printf '\n%s\n%s\n' \
        '[archlinuxcn]' \
        'Server = https://repo.archlinuxcn.org/$arch' \
        >> /etc/pacman.conf; \
    pacman-key --init; \
    pacman-key --populate archlinux; \
    pacman -Syu --noconfirm --needed \
        archlinux-keyring \
        archlinuxcn-keyring; \
    pacman -S --noconfirm --needed \
        base-devel \
        ca-certificates \
        curl \
        fish \
        git \
        paru \
        starship \
        sudo; \
    rm -rf /var/cache/pacman/pkg/*

# Add EndeavourOS repositories and packages without replacing the Arch mirrorlist.
RUN set -eux; \
    curl -fsSL https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/master/endeavouros-mirrorlist/endeavouros-mirrorlist \
        -o /etc/pacman.d/endeavouros-mirrorlist; \
    printf '\n%s\n%s\n%s\n' \
        '[endeavouros]' \
        'SigLevel = PackageRequired' \
        'Include = /etc/pacman.d/endeavouros-mirrorlist' \
        >> /etc/pacman.conf; \
    touch /etc/lsb-release; \
    pacman-key --recv-key 0F20FADC599D1C46EB556455AED8858E4B9813F1 --keyserver keyserver.ubuntu.com; \
    pacman-key --lsign-key 0F20FADC599D1C46EB556455AED8858E4B9813F1; \
    pacman-key --recv-key 497AF50C92AD2384C56E1ACA003DB8B0CB23504F --keyserver keyserver.ubuntu.com; \
    pacman-key --lsign-key 497AF50C92AD2384C56E1ACA003DB8B0CB23504F; \
    pacman -Sy --noconfirm --needed \
        endeavouros-keyring \
        endeavouros-mirrorlist \
        endeavouros-theming \
        eos-hooks; \
    rm -rf /var/cache/pacman/pkg/*

# Prepare fish defaults for root and users created later with useradd -m.
# The mise fish installer writes $HOME literally, so normalize the skeleton path.
RUN set -eux; \
    mkdir -p /etc/skel/.config/fish; \
    curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o /tmp/omf-install; \
    for attempt in 1 2 3; do \
        rm -rf /etc/skel/.local/share/omf /etc/skel/.config/omf /etc/skel/.config/fish/conf.d/omf.fish; \
        HOME=/etc/skel fish /tmp/omf-install --noninteractive --yes && break; \
        test "$attempt" = 3 && exit 1; \
        sleep 5; \
    done; \
    rm -f /tmp/omf-install; \
    starship preset pastel-powerline -o /etc/skel/.config/starship.toml; \
    printf '\n%s\n' 'starship init fish | source' >> /etc/skel/.config/fish/config.fish; \
    for attempt in 1 2 3; do \
        curl -fsSL https://mise.run/fish | HOME=/etc/skel SHELL=/usr/bin/fish sh && break; \
        test "$attempt" = 3 && exit 1; \
        sleep 5; \
    done; \
    sed -i 's#/etc/skel/.local/bin/mise#~/.local/bin/mise#g' /etc/skel/.config/fish/config.fish; \
    cp -a /etc/skel/. /root/

# Modify /etc/os-release to reflect EndeavourOS
RUN echo 'NAME="EndeavourOS"' > /etc/os-release && \
    echo 'PRETTY_NAME="EndeavourOS"' >> /etc/os-release && \
    echo 'ID="endeavouros"' >> /etc/os-release && \
    echo 'ID_LIKE="arch"' >> /etc/os-release && \
    echo 'BUILD_ID=rolling' >> /etc/os-release && \
    echo 'ANSI_COLOR="38;2;23;147;209"' >> /etc/os-release && \
    echo 'HOME_URL="https://endeavouros.com"' >> /etc/os-release && \
    echo 'DOCUMENTATION_URL="https://discovery.endeavouros.com"' >> /etc/os-release && \
    echo 'SUPPORT_URL="https://forum.endeavouros.com"' >> /etc/os-release && \
    echo 'BUG_REPORT_URL="https://forum.endeavouros.com/c/general-system/endeavouros-installation"' >> /etc/os-release && \
    echo 'PRIVACY_POLICY_URL="https://endeavouros.com/privacy-policy-2"' >> /etc/os-release && \
    echo 'LOGO="endeavouros"' >> /etc/os-release

# Set fish as the default interactive shell.
CMD ["fish"]
