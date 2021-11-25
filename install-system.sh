#!/bin/sh

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log" >&2)

# read .env
while read line; do export $line; done < .env

script_name="$(basename "$0")"
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

copy() {
    orig_file="$dotfiles_dir/$1"
    dest_file="/$1"

    mkdir -p "$(dirname "$orig_file")"
    mkdir -p "$(dirname "$dest_file")"

    rm -rf "$dest_file"

    cp -R "$orig_file" "$dest_file"
    echo "$dest_file <= $orig_file"
}

echo -e "\n### copying files"
copy "etc/docker/daemon.json"
copy "etc/yum.repos.d/fedora.repo"
copy "etc/yum.repos.d/fedora-modular.repo"
copy "etc/yum.repos.d/fedora-updates.repo"
copy "etc/yum.repos.d/fedora-updates-modular.repo"

echo -e "\n### configuring flatpak"
flatpak remote-delete flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "\n### installing packages"
rpm-ostree refresh-md
rpm-ostree install --idempotent git starship git-delta exa ripgrep neovim
rpm-ostree install --idempotent go java-1.8.0-openjdk-devel rust cargo
rpm-ostree install --idempotent wqy-microhei-fonts wqy-zenhei-fonts

flatpak uninstall --delete-data org.fedoraproject.MediaWriter
rpm-ostree override remove firefox

flatpak install -y --noninteractive --or-update flathub org.gnome.Calendar
flatpak install -y --noninteractive --or-update flathub org.gnome.Evince
flatpak install -y --noninteractive --or-update flathub org.gnome.Music
flatpak install -y --noninteractive --or-update flathub org.gnome.Geary
flatpak install -y --noninteractive --or-update flathub net.agalwood.Motrix
flatpak install -y --noninteractive --or-update flathub io.github.celluloid_player.Celluloid
flatpak install -y --noninteractive --or-update flathub com.github.gmg137.netease-cloud-music-gtk
flatpak install -y --noninteractive --or-update flathub com.github.tchx84.Flatseal

flatpak install -y --noninteractive --or-update flathub com.vscodium.codium
flatpak install -y --noninteractive --or-update flathub rest.insomnia.Insomnia
flatpak install -y --noninteractive --or-update flathub com.github.alainm23.planner
flatpak install -y --noninteractive --or-update flathub net.xmind.ZEN
flatpak install -y --noninteractive --or-update flathub md.obsidian.Obsidian
flatpak install -y --noninteractive --or-update flathub io.typora.Typora
flatpak install -y --noninteractive --or-update flathub me.hyliu.fluentreader
flatpak install -y --noninteractive --or-update flathub com.github.johnfactotum.Foliate
flatpak install -y --noninteractive --or-update flathub io.github.shiftey.Desktop
flatpak install -y --noninteractive --or-update flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install -y --noninteractive --or-update flathub org.mozilla.firefox

echo -e "\n### configuring user"
for GROUP in wheel network; do
    groupadd -rf "$GROUP"
    gpasswd -a "$USER" "$GROUP"
done

