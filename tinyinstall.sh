#!/bin/sh
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
pacman -S --noconfirm grub efibootmgr os-prober dhcpcd
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchToast
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable dhcpcd
EOF
umount -R /mnt&&reboot