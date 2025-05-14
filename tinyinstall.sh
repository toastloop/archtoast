#!/bin/sh
loadkeys us
[ ! -d /sys/firmware/efi ]&&exit 1
ping -c1 -w1 8.8.8.8>/dev/null||exit 1
ping -c1 -w1 google.com>/dev/null||exit 1
d=$(lsblk -dnpo NAME,TYPE|awk '$2=="disk"{print $1;exit}')
parted $d --script mklabel gpt mkpart primary 1MiB 512MiB mkpart primary 512MiB 100% set 1 esp on set 1 boot on
mkfs.fat -F32 -n BOOT ${d}1& mkfs.ext4 -L ROOT ${d}2&
(reflector --country US --latest 5 --sort rate --save /etc/pacman.d/mirrorlist||echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch'>/etc/pacman.d/mirrorlist)&
wait
mount ${d}2 /mnt&&mkdir -p /mnt/boot&&mount ${d}1 /mnt/boot
pacstrap -K /mnt base linux&&genfstab -U /mnt>>/mnt/etc/fstab
arch-chroot /mnt /bin/sh<<EOF
ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
hwclock --systohc
echo en_US.UTF-8 UTF-8>/etc/locale.gen&&locale-gen
echo en_US.UTF-8>/etc/locale.conf
echo KEYMAP=us>/etc/vconsole.conf
echo archtoast>/etc/hostname
echo root:root|chpasswd
useradd -m -G wheel -s /bin/bash matt
echo matt:matt|chpasswd
echo '%wheel ALL=(ALL) ALL'>>/etc/sudoers
pacman -S --noconfirm grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchToast
grub-mkconfig -o /boot/grub/grub.cfg
EOF
umount -R /mnt&&sleep 5&&reboot