#!/bin/bash

FEDORA_VERSION=$(rpm -E %fedora)

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/42/x86_64/repoview/index.html&protocol=https&redirect=1

# removes toolbox and fedora flathub
dnf5 install -y distrobox flatpak # flatpak must be specified or else
                                  # fedora-flathub-remote will
                                  # autoremove it!
dnf5 remove -y toolbox fedora-flathub-remote # dnf5 cleans up after itself as it's
                                             # a well-behaved package manager

# installs flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Also remove the applications that I don't really want as packages
# for codec reasons
dnf5 remove -y firefox thunderbird elisa

# this installs the whole virtualization group
# the --with-optional version includes all architectures supported by QEMU
# VirtualBox is added here because of rpmfusion being here
dnf5 group install -y --with-optional virtualization 

# ublue package
dnf5 -y copr enable ublue-os/packages
dnf5 install -y ublue-brew ublue-fastfetch
dnf5 -y copr disable ublue-os/packages

# dnf5 install -y distribution-gpg-keys
sudo rpmkeys --import /usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-free-fedora-$FEDORA_VERSION
dnf5 --setopt=localpkg_gpgcheck=1 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1
dnf5 install -y VirtualBox
dnf5 remove -y rpmfusion-free-release-$FEDORA_VERSION
dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

# Installs 86box
# dnf5 -y copr enable rob72/86Box
# dnf5 install -y 86Box
# mkdir -p /usr/local/share/86Box/
# curl -sL https://github.com/86Box/roms/archive/refs/tags/$BOX86_VERSION.tar.gz -o /usr/local/share/86Box/$BOX86_VERSION.tar.gz
# tar xzf /usr/local/share/86Box/$BOX86_VERSION.tar.gz
# mv $BOX86_VERSION-roms roms
# dnf5 -y copr disable rob72/86Box #disables COPR so it doesn't end up on final image

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable libvirtd




