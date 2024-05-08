#!/bin/bash
IGNITION_CONFIG="/var/lib/libvirt/boot/helium.ign"
IGNITION_DEVICE_ARG=(--qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}")

sudo restorecon /var/lib/libvirt/boot/helium.ign

sudo virt-install \
        --connect="qemu:///system" \
        --name="helium" \
        --vcpus="2" \
        --memory="4096" \
        --boot uefi \
        --os-variant="fedora-coreos-stable" \
        --import \
        --graphics=none \
        --disk="size=20,backing_store=/var/lib/libvirt/images/fedora-coreos-39.20240407.3.0-qemu.x86_64.qcow2" \
        --disk="size=80,pool=data" \
        --network type=direct,source=enp1s0 \
        "${IGNITION_DEVICE_ARG[@]}"
