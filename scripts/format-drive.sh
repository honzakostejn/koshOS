#!/bin/bash

# Completely wipe MBR/GPT structures
sudo dd if=/dev/zero of=/dev/sda bs=1M count=200
sudo dd if=/dev/zero of=/dev/sda bs=1M count=200 seek=$(($(blockdev --getsz /dev/sda)/2048-200))
sync

# Create new MBR partition table
sudo parted /dev/sda mklabel msdos
sync

# Create a single partition using all available space
sudo parted -a optimal /dev/sda mkpart primary 1MiB 100%
sync

# Format with FAT32
sudo mkfs.vfat -F 32 /dev/sda1
sync

echo "Process completed"