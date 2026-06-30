#!/usr/bin/env bash
set -euxo pipefail

mkdir -p /etc/skel/.config/fish
curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o /tmp/omf-install

for attempt in 1 2 3; do
    rm -rf \
        /etc/skel/.local/share/omf \
        /etc/skel/.config/omf \
        /etc/skel/.config/fish/conf.d/omf.fish

    HOME=/etc/skel fish /tmp/omf-install --noninteractive --yes && break
    test "$attempt" = 3 && exit 1
    sleep 5
done

rm -f /tmp/omf-install

starship preset pastel-powerline -o /etc/skel/.config/starship.toml
printf '\n%s\n' "starship init fish | source" >> /etc/skel/.config/fish/config.fish

for attempt in 1 2 3; do
    curl -fsSL https://mise.run/fish | HOME=/etc/skel SHELL=/usr/bin/fish sh && break
    test "$attempt" = 3 && exit 1
    sleep 5
done

sed -i "s#/etc/skel/.local/bin/mise#~/.local/bin/mise#g" /etc/skel/.config/fish/config.fish
cp -a /etc/skel/. /root/
