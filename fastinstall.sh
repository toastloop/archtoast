#!/bin/sh
clear
loadkeys us
setfont Lat2-Terminus16
efi=$(cat /sys/firmware/efi/fw_platform_size)
case $efi in
    64) echo "UEFI 64" ;;
    32) echo "UEFI 32" ;;
    *) echo "BIOS" ;;
esac
ping -c 1 -w 1 8.8.8.8 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no internet"
    exit 1
fi
ping -c 1 -w 1 google.com > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no dns"
    exit 1
fi
disk=$(lsblk -dnpo NAME,TYPE | awk '$2=="disk"{print $1; exit}');
echo "found disk: $disk"
echo "continue? (y/n)"
read -r answer
if [ "$answer" != "y" ]; then
    exit 1
fi
parted "$disk" --script mklabel gpt
parted "$disk" --script mkpart primary 1MiB 512MiB
parted "$disk" --script mkpart primary 512MiB 100%
parted "$disk" --script set 1 esp on
parted "$disk" --script set 1 boot on
mkfs.fat -F32 -n BOOT "$disk"1
mkfs.ext4 -L ROOT "$disk"2
mount "$disk"2 /mnt
mkdir -p /mnt/boot
mount "$disk"1 /mnt/boot
reflector --country 'United States' --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash -c 'ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime'
arch-chroot /mnt /bin/bash -c 'hwclock --systohc'
arch-chroot /mnt /bin/bash -c 'echo "en_US.UTF-8 UTF-8" > /etc/locale.gen'
arch-chroot /mnt /bin/bash -c 'locale-gen'
arch-chroot /mnt /bin/bash -c 'echo "en_US.UTF-8" > /etc/locale.conf'
arch-chroot /mnt /bin/bash -c 'echo "KEYMAP=us" > /etc/vconsole.conf'
arch-chroot /mnt /bin/bash -c 'echo "archtoast" > /etc/hostname'
arch-chroot /mnt /bin/bash -c 'mkinitcpio -P'
arch-chroot /mnt /bin/bash -c 'echo "root:root" | chpasswd'
arch-chroot /mnt /bin/bash -c 'useradd -m -G wheel -s /bin/bash matt'
arch-chroot /mnt /bin/bash -c 'echo "matt:matt" | chpasswd'
arch-chroot /mnt /bin/bash -c 'echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers'
arch-chroot /mnt /bin/bash -c 'pacman -S --noconfirm grub efibootmgr os-prober'
arch-chroot /mnt /bin/bash -c 'grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchToast'
arch-chroot /mnt /bin/bash -c 'grub-mkconfig -o /boot/grub/grub.cfg'
umount -R /mnt
echo "done"
echo "rebooting in 5 seconds..."
sleep 5
reboot