#!/bin/bash

BOX86_VERSION="v4.2.1"

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/42/x86_64/repoview/index.html&protocol=https&redirect=1

# Installs workstation components
dnf5 install -y @workstation-product @workstation-ostree-support

# removes toolbox and fedora flathub
dnf5 remove -y toolbox fedora-flathub-remote
dnf5 install -y distrobox # dont remove deps shared between distrobox and toolbox
dnf5 autoremove -y

# installs tui browsers because I like them
dnf5 install -y @text-internet

# this installs the whole virtualization group
# the --with-optional version includes all architectures supported by QEMU
dnf5 group install -y --with-optional virtualization

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

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
