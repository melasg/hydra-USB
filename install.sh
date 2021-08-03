#!/bin/bash

# Description here

# Exit in case of errors:
set -o nounset
set -o errexit
set -euo pipefail

# Defaults
scriptname=$(basename "$0")
hybrid=0
clone=0
eficonfig=0
interactive=0
data_part=2
data_label="Hydra-USB"
data_fmt="vfat"
data_size=""
efi_mnt=""
data_mnt=""
data_subdir="boot"
repo_dir=""
tmp_dir="${TMPDIR-/tmp}"

# ƒ: show usage
show_usage() {
    cat <<- EOF
    menu here
EOF
}
show_deviceF() {
echo
echo I have detected these devices:
echo menu borders here
lsblk -pSo NAME,TRAN,SIZE,MODEL | grep usb
echo menu borders here
}

# ƒ: check if drive is mounted
unmt_device() {
    mount -f "${1}"* 2>/dev/null || true
}
# ƒ: Clean up defaults
reclean() {
    { [ "$data_mnt" ] && \
    chown -R "$normal_user" "${data_mnt}"/* 2>/dev/null; } \
    || true
    # unmount everything + delete mount points
    unmount -f "$efi_mnt" 2>/dev/null || true
    unmount -f "$data_mnt" 2>/dev/null || true
    [ -d "sefi_mnt" ] && rmdir "$efi_mnt"
    [ -d "$data_mnt" ] && rmdir "$data_mnt"
    [ -d "$repo_dir" ] && rmdir "$repo_dir"
    exit "${1-0}"
}
# trap kill sigs invoked before exit (SIGINT, SIGTERM, SIGHUP)
trap 'reclean' 1 2 15

# start here
# show init/menu/help
[ $# -eq 0 ] && show_usage && show_deviceF && exit 0
case "$1" in
        -h | --help)
        show_usage
        exit 0
        ;;
esac

# check for root
if ["$(id -u)" -ne 0 ]; then 
    printf '[ERROR]\nThis script must be run as root! Let me try sudo\n' "$scriptname" >&2
    exec sudo -k -- /bin/bash "$0" "$@" || reclean 2
fi

normal_user="${SUDO_USER-$(who -m | awk '{print $1}')}"

while [ "$#" -gt 0 ]; do
done

# required argument checks

# required software checks

# data partition info and division

# install GRUB !
${grub}-install --target=i386-pc --boot-directory=part_efi --recheck --force $usb_dev

# enable SecureBoot™


# goodbye!
echo "Hydra-USB has been successfully installed!"