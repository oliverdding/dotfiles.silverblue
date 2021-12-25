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

unzip_from_link() {
    local download_link=$1; shift || return 1
    local temporary_dir

    temporary_dir=$(mktemp -d) \
    && curl -LO "${download_link:-}" \
    && unzip -d "$temporary_dir" \*.zip \
    && rm -rf \*.zip \
    && mv "$temporary_dir"/* ${1:-"$HOME/Downloads"} \
    && rm -rf $temporary_dir
}

echo -e "\n### copying files"
copy "etc/yum.repos.d/fedora.repo"
copy "etc/yum.repos.d/fedora-modular.repo"
copy "etc/yum.repos.d/fedora-updates.repo"
copy "etc/yum.repos.d/fedora-updates-modular.repo"
curl -sSL https://www.scala-sbt.org/sbt-rpm.repo -o /etc/yum.repos.d/sbt-rpm.repo
#echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

echo -e "\n### configuring flatpak"
flatpak --user config --set languages "en"
flatpak --user override --env=LC_ALL=en_US.UTF-8
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub

echo -e "\n### installing packages"
rpm-ostree refresh-md
rpm-ostree cleanup -m
rpm-ostree install --idempotent git starship git-delta exa ripgrep neovim zoxide fzf bat gitui fd ffmpeg-libs mozilla-openh264 ffmpegthumbnailer p7zip unrar webp-pixbuf-loader
rpm-ostree install --idempotent llvm clang lld lldb gdb
rpm-ostree install --idempotent golang
rpm-ostree install --idempotent java-1.8.0-openjdk-devel scala sbt
rpm-ostree install --idempotent rust cargo cargo-bloat
rpm-ostree install --idempotent gnome-extensions-app gnome-tweaks
rpm-ostree install --idempotent wqy-microhei-fonts wqy-zenhei-fonts

flatpak uninstall -y --noninteractive --delete-data org.fedoraproject.MediaWriter
#rpm-ostree override remove firefox gnome-tour yelp

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
flatpak install -y --noninteractive --or-update com.github.marktext.marktext
flatpak install -y --noninteractive --or-update flathub me.hyliu.fluentreader
flatpak install -y --noninteractive --or-update flathub com.github.johnfactotum.Foliate
flatpak install -y --noninteractive --or-update flathub io.github.shiftey.Desktop
flatpak install -y --noninteractive --or-update flathub com.github.IsmaelMartinez.teams_for_linux
#flatpak install -y --noninteractive --or-update flathub org.mozilla.firefox

echo -e "\n### configuring user"
for GROUP in wheel network; do
    groupadd -rf "$GROUP"
    gpasswd -a "$USER" "$GROUP"
done

echo -e "\n### Installing fonts"
mkdir -p ${XDG_DATA_HOME}/fonts/FiraCode
mkdir -p ${XDG_DATA_HOME}/fonts/JetBrainsMono
mkdir -p ${XDG_DATA_HOME}/fonts/SourceCodePro
unzip_from_link "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip" "${XDG_DATA_HOME}/fonts/FiraCode"
unzip_from_link "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip" "${XDG_DATA_HOME}/fonts/JetBrainsMono"
unzip_from_link "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip" "${XDG_DATA_HOME}/fonts/SourceCodePro"

fc-cache -v

