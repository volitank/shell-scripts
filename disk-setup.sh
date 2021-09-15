#!/bin/sh

#Let's make sure we're root

if ! [ $(id -u) = 0 ]; then
   echo "Please run with sudo"
   exit 1
fi

volume='ubuntu'
disk='sda'
luks_name='root_crypt'

# def Partition_Types():
	# Partition Types
	# 1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
	# 2 MBR partition scheme           024DEE41-33E7-11D3-9D69-0008C781F39F
	# 3 Intel Fast Flash               D3BFE2DE-3DAF-11DF-BA40-E3A556D89593
	# 4 BIOS boot                      21686148-6449-6E6F-744E-656564454649
	# 5 Sony boot partition            F4019732-066E-4E12-8273-346C5641494F
	# 6 Lenovo boot partition          BFBFAFE7-A34F-448A-9A5B-6213EB736C22
	# 7 PowerPC PReP boot              9E1A2D38-C612-4316-AA26-8B49521E5A8B
	# 8 ONIE boot                      7412F7D5-A156-4B13-81DC-867174929325
	# 9 ONIE config                    D4E6E2CD-4469-46F3-B5CB-1BFF57AFC149
	# 10 Microsoft reserved             E3C9E316-0B5C-4DB8-817D-F92DF00215AE
	# 11 Microsoft basic data           EBD0A0A2-B9E5-4433-87C0-68B6B72699C7
	# 12 Microsoft LDM metadata         5808C8AA-7E8F-42E0-85D2-E1E90434CFB3
	# 13 Microsoft LDM data             AF9B60A0-1431-4F62-BC68-3311714A69AD
	# 14 Windows recovery environment   DE94BBA4-06D1-4D40-A16A-BFD50179D6AC
	# 15 IBM General Parallel Fs        37AFFC90-EF7D-4E96-91C3-2D7AE055B174
	# 16 Microsoft Storage Spaces       E75CAF8F-F680-4CEE-AFA3-B001E56EFC2D
	# 17 HP-UX data                     75894C1E-3AEB-11D3-B7C1-7B03A0000000
	# 18 HP-UX service                  E2A1E728-32E3-11D6-A682-7B03A0000000
	# 19 Linux swap                     0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
	# 20 Linux filesystem               0FC63DAF-8483-4772-8E79-3D69D8477DE4
	# 21 Linux server data              3B8F8425-20E0-4F3B-907F-1A25A76F98E8
	# 22 Linux root (x86)               44479540-F297-41B2-9AF7-D131D5F0458A
	# 23 Linux root (x86-64)            4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
	# 24 Linux root (ARM)               69DAD710-2CE4-4E3C-B16C-21A1D49ABED3
	# 25 Linux root (ARM-64)            B921B045-1DF0-41C3-AF44-4C6F280D3FAE
	# 26 Linux root (IA-64)             993D8D3D-F80E-4225-855A-9DAF8ED7EA97
	# 27 Linux reserved                 8DA63339-0007-60C0-C436-083AC8230908
	# 28 Linux home                     933AC7E1-2EB4-4F13-B844-0E14E2AEF915
	# 29 Linux RAID                     A19D880F-05FC-4D3B-A006-743F0F84911E
	# 30 Linux LVM                      E6D6D379-F507-44C2-A23C-238F2A3DF928
	# 31 Linux variable data            4D21B016-B534-45C2-A9FB-5C16E091FD2D
	# 32 Linux temporary data           7EC6F557-3BC5-4ACA-B293-16EF5DF639D1
	# 33 Linux /usr (x86)               75250D76-8CC6-458E-BD66-BD47CC81A812
	# 34 Linux /usr (x86-64)            8484680C-9521-48C6-9C11-B0720656F69E
	# 35 Linux /usr (ARM)               7D0359A3-02B3-4F0A-865C-654403E70625
	# 36 Linux /usr (ARM-64)            B0E01050-EE5F-4390-949A-9101B17104E9
	# 37 Linux /usr (IA-64)             4301D2A6-4E3B-4B2A-BB94-9E0B2C4225EA
	# 38 Linux root verity (x86)        D13C5D3B-B5D1-422A-B29F-9454FDC89D76
	# 39 Linux root verity (x86-64)     2C7357ED-EBD2-46D9-AEC1-23D437EC2BF5
	# 40 Linux root verity (ARM)        7386CDF2-203C-47A9-A498-F2ECCE45A2D6
	# 41 Linux root verity (ARM-64)     DF3300CE-D69F-4C92-978C-9BFB0F38D820
	# 42 Linux root verity (IA-64)      86ED10D5-B607-45BB-8957-D350F23D0571
	# 43 Linux /usr verity (x86)        8F461B0D-14EE-4E81-9AA9-049B6FB97ABD
	# 44 Linux /usr verity (x86-64)     77FF5F63-E7B6-4633-ACF4-1565B864C0E6
	# 45 Linux /usr verity (ARM)        C215D751-7BCD-4649-BE90-6627490A4C05
	# 46 Linux /usr verity (ARM-64)     6E11A4E7-FBCA-4DED-B9E9-E1A512BB664E
	# 47 Linux /usr verity (IA-64)      6A491E03-3BE7-4545-8E38-83320E0EA880
	# 48 Linux extended boot            BC13C2FF-59E6-4262-A352-B275FD6F7172
	# 49 Linux user's home              773f91ef-66d4-49b5-bd83-d683bf40ad16
	# 50 FreeBSD data                   516E7CB4-6ECF-11D6-8FF8-00022D09712B
	# 51 FreeBSD boot                   83BD6B9D-7F41-11DC-BE0B-001560B84F0F
	# 52 FreeBSD swap                   516E7CB5-6ECF-11D6-8FF8-00022D09712B
	# 53 FreeBSD UFS                    516E7CB6-6ECF-11D6-8FF8-00022D09712B
	# 54 FreeBSD ZFS                    516E7CBA-6ECF-11D6-8FF8-00022D09712B
	# 55 FreeBSD Vinum                  516E7CB8-6ECF-11D6-8FF8-00022D09712B
	# 56 Apple HFS/HFS+                 48465300-0000-11AA-AA11-00306543ECAC
	# 57 Apple APFS                     7C3457EF-0000-11AA-AA11-00306543ECAC
	# 58 Apple UFS                      55465300-0000-11AA-AA11-00306543ECAC
	# 59 Apple RAID                     52414944-0000-11AA-AA11-00306543ECAC
	# 60 Apple RAID offline             52414944-5F4F-11AA-AA11-00306543ECAC
	# 61 Apple boot                     426F6F74-0000-11AA-AA11-00306543ECAC
	# 62 Apple label                    4C616265-6C00-11AA-AA11-00306543ECAC
	# 63 Apple TV recovery              5265636F-7665-11AA-AA11-00306543ECAC
	# 64 Apple Core storage             53746F72-6167-11AA-AA11-00306543ECAC
	# 65 Solaris boot                   6A82CB45-1DD2-11B2-99A6-080020736631
	# 66 Solaris root                   6A85CF4D-1DD2-11B2-99A6-080020736631
	# 67 Solaris /usr & Apple ZFS       6A898CC3-1DD2-11B2-99A6-080020736631
	# 68 Solaris swap                   6A87C46F-1DD2-11B2-99A6-080020736631
	# 69 Solaris backup                 6A8B642B-1DD2-11B2-99A6-080020736631
	# 70 Solaris /var                   6A8EF2E9-1DD2-11B2-99A6-080020736631
	# 71 Solaris /home                  6A90BA39-1DD2-11B2-99A6-080020736631
	# 72 Solaris alternate sector       6A9283A5-1DD2-11B2-99A6-080020736631
	# 73 Solaris reserved 1             6A945A3B-1DD2-11B2-99A6-080020736631
	# 74 Solaris reserved 2             6A9630D1-1DD2-11B2-99A6-080020736631
	# 75 Solaris reserved 3             6A980767-1DD2-11B2-99A6-080020736631
	# 76 Solaris reserved 4             6A96237F-1DD2-11B2-99A6-080020736631
	# 77 Solaris reserved 5             6A8D2AC7-1DD2-11B2-99A6-080020736631
	# 78 NetBSD swap                    49F48D32-B10E-11DC-B99B-0019D1879648
	# 79 NetBSD FFS                     49F48D5A-B10E-11DC-B99B-0019D1879648
	# 80 NetBSD LFS                     49F48D82-B10E-11DC-B99B-0019D1879648
	# 81 NetBSD concatenated            2DB519C4-B10E-11DC-B99B-0019D1879648
	# 82 NetBSD encrypted               2DB519EC-B10E-11DC-B99B-0019D1879648
	# 83 NetBSD RAID                    49F48DAA-B10E-11DC-B99B-0019D1879648
	# 84 ChromeOS kernel                FE3A2A5D-4F32-41A7-B725-ACCC3285A309
	# 85 ChromeOS root fs               3CB8E202-3B7E-47DD-8A3C-7FF2A13CFCEC
	# 86 ChromeOS reserved              2E0A753D-9E48-43B0-8337-B15192CB1B5E
	# 44 Linux /usr verity (x86-64)     77FF5F63-E7B6-4633-ACF4-1565B864C0E6
	# 45 Linux /usr verity (ARM)        C215D751-7BCD-4649-BE90-6627490A4C05
	# 46 Linux /usr verity (ARM-64)     6E11A4E7-FBCA-4DED-B9E9-E1A512BB664E
	# 47 Linux /usr verity (IA-64)      6A491E03-3BE7-4545-8E38-83320E0EA880
	# 48 Linux extended boot            BC13C2FF-59E6-4262-A352-B275FD6F7172
	# 49 Linux user's home              773f91ef-66d4-49b5-bd83-d683bf40ad16
	# 50 FreeBSD data                   516E7CB4-6ECF-11D6-8FF8-00022D09712B
	# 51 FreeBSD boot                   83BD6B9D-7F41-11DC-BE0B-001560B84F0F
	# 52 FreeBSD swap                   516E7CB5-6ECF-11D6-8FF8-00022D09712B
	# 53 FreeBSD UFS                    516E7CB6-6ECF-11D6-8FF8-00022D09712B
	# 54 FreeBSD ZFS                    516E7CBA-6ECF-11D6-8FF8-00022D09712B
	# 55 FreeBSD Vinum                  516E7CB8-6ECF-11D6-8FF8-00022D09712B
	# 56 Apple HFS/HFS+                 48465300-0000-11AA-AA11-00306543ECAC
	# 57 Apple APFS                     7C3457EF-0000-11AA-AA11-00306543ECAC
	# 58 Apple UFS                      55465300-0000-11AA-AA11-00306543ECAC
	# 59 Apple RAID                     52414944-0000-11AA-AA11-00306543ECAC
	# 60 Apple RAID offline             52414944-5F4F-11AA-AA11-00306543ECAC
	# 61 Apple boot                     426F6F74-0000-11AA-AA11-00306543ECAC
	# 62 Apple label                    4C616265-6C00-11AA-AA11-00306543ECAC
	# 63 Apple TV recovery              5265636F-7665-11AA-AA11-00306543ECAC
	# 64 Apple Core storage             53746F72-6167-11AA-AA11-00306543ECAC
	# 65 Solaris boot                   6A82CB45-1DD2-11B2-99A6-080020736631
	# 66 Solaris root                   6A85CF4D-1DD2-11B2-99A6-080020736631
	# 67 Solaris /usr & Apple ZFS       6A898CC3-1DD2-11B2-99A6-080020736631
	# 68 Solaris swap                   6A87C46F-1DD2-11B2-99A6-080020736631
	# 69 Solaris backup                 6A8B642B-1DD2-11B2-99A6-080020736631
	# 70 Solaris /var                   6A8EF2E9-1DD2-11B2-99A6-080020736631
	# 71 Solaris /home                  6A90BA39-1DD2-11B2-99A6-080020736631
	# 72 Solaris alternate sector       6A9283A5-1DD2-11B2-99A6-080020736631
	# 73 Solaris reserved 1             6A945A3B-1DD2-11B2-99A6-080020736631
	# 74 Solaris reserved 2             6A9630D1-1DD2-11B2-99A6-080020736631
	# 75 Solaris reserved 3             6A980767-1DD2-11B2-99A6-080020736631
	# 76 Solaris reserved 4             6A96237F-1DD2-11B2-99A6-080020736631
	# 77 Solaris reserved 5             6A8D2AC7-1DD2-11B2-99A6-080020736631
	# 78 NetBSD swap                    49F48D32-B10E-11DC-B99B-0019D1879648
	# 79 NetBSD FFS                     49F48D5A-B10E-11DC-B99B-0019D1879648
	# 80 NetBSD LFS                     49F48D82-B10E-11DC-B99B-0019D1879648
	# 81 NetBSD concatenated            2DB519C4-B10E-11DC-B99B-0019D1879648
	# 82 NetBSD encrypted               2DB519EC-B10E-11DC-B99B-0019D1879648
	# 83 NetBSD RAID                    49F48DAA-B10E-11DC-B99B-0019D1879648
	# 84 ChromeOS kernel                FE3A2A5D-4F32-41A7-B725-ACCC3285A309
	# 85 ChromeOS root fs               3CB8E202-3B7E-47DD-8A3C-7FF2A13CFCEC
	# 86 ChromeOS reserved              2E0A753D-9E48-43B0-8337-B15192CB1B5E
# Defined for vs code collapse

# Do some argument testing
if [ $# -eq 0 ]
	then
	echo "No arguments supplied"
	exit
fi

if [ $# -gt 1 ]
	then
	echo "too many arguments supplied!"
	exit
fi

if [ $1 != "disk" ] && [ $1 != "init" ]; then
	echo "usage: disk.sh [disk|init]"
	exit
fi

if [ $1 = "disk" ]; then

	(
	# Create the parition table and the first partition
	echo	g	# Create a new empty DOS partition table
	echo	n	# Add a new partition
	echo	1	# Partition number
	echo		# First sector (Accept default: 1)
	echo	+512M	# Last sector (Accept default: varies)
	# Create the second partition
	echo	n	# Add a new partition
	echo	2	# Partition number
	echo		# First sector (Accept default: 1)
	echo	+1536M	# Last sector (Accept default: varies)
	# Create the last partition
	echo	n	# Add a new partition
	echo	3	# Partition number
	echo		# First sector (Accept default: 1)
	echo		# Last sector (Accept default: varies)
	# Create the first partition type
	echo	t	# Change partition type
	echo	1	# Partition number
	echo	1	# EFI System
	# Create the second partition type
	echo	t	# Change partition type
	echo	2	# Partition number
	echo	48	# Linux extended boot
	# Create the last partition type
	echo	t	# Change partition type
	echo	3	# Partition number
	echo	30	# Linux LVM
	echo	w	# Write changes
	) | fdisk /dev/$disk

	echo "we're going to format the luks partition. please enter a password."
	echo "you will be asked to verify it"
	echo ""
	cryptsetup luksFormat --hash=sha512 --key-size=512 --verify-passphrase /dev/${disk}3 || exit 1
	echo "now we need to unlock the disk, I know this seems redundant"
	echo ""

	cryptsetup luksOpen /dev/${disk}3 $luks_name || exit 1
	pvcreate /dev/mapper/$luks_name || exit 1
	vgcreate $volume /dev/mapper/$luks_name || exit 1
	lvcreate -n root -L 20G $volume || exit 1
	lvcreate -n var -L 8G $volume || exit 1
	lvcreate -n home -l 100%FREE $volume || exit 1

	# We need to format the efi partition. For some reason ubiquity won't
	mkfs.fat -F32 /dev/${disk}1
	echo ""
	echo "your partitioning has completed"
	echo "please continue with the installation"
	echo "once you reach the end click continue testing"
	echo "then run disk.sh init"
fi

if [ $1 = "init" ] ; then

	# Get uuid of the encrypted part we just created
	luks_part_id=$(blkid -o value /dev/${disk}3 | head -n 1)

	# This one will get the "UUID=" part
	#blkid | awk '/crypto/ {print $2}'

	# This one will only get the UUID
	#blkid -o value /dev/sda3 | head -n 1

	#Mount our system for our
	chroot_dir='/mnt/ubuntu'
	mkdir -p $chroot_dir
	
	# Make sure our volumes aren't mounted
	umount -l /dev/$volume/root && echo "umounted /dev/$volume/root"
	umount -l /dev/$volume/home && echo "umounted /dev/$volume/home"
	umount -l /dev/$volume/var	&& echo "umounted /dev/$volume/var"

	# Mount our  directories.
	mount /dev/$volume/root $chroot_dir
	mount /dev/$volume/home $chroot_dir/home # this is probably not necessary
	mount /dev/$volume/var $chroot_dir/var

	mount /dev/${disk}2 $chroot_dir/boot
	mount /dev/${disk}1 $chroot_dir/boot/efi
	mount --bind /dev $chroot_dir/dev # I'm not entirely sure this is necessary
	mount --bind /run/lvm $chroot_dir/run/lvm

	echo "$luks_name UUID=$luks_part_id none luks,discard" > $chroot_dir/etc/crypttab

	chroot $chroot_dir /bin/sh -c \
	"mount -t proc proc /proc; \
	mount -t sysfs sys /sys; \
	mount -t devpts devpts /dev/pts; \
	update-initramfs -k all -c; \
	update-grub" || echo "Something went wrong"; exit 1

# This was my original method of interfacing with the chroot
# 	echo \
# '#!/bin/sh
# luks_part_id=$luks_part_id
# luks_name=$luks_name
# mount -t proc proc /proc
# mount -t sysfs sys /sys
# mount -t devpts devpts /dev/pts
# echo "$luks_name UUID=$luks_part_id none luks,discard" > /etc/crypttab
# update-initramfs -k all -c
# update-grub' > $chroot_dir/chroot_update.sh
# chmod +x $chroot_dir/chroot_update.sh

# chroot $chroot_dir /bin/sh -c ./chroot_update.sh || exit 1

	# Echo you're finished

	echo "You're all done. Reboot into your new system."
fi
