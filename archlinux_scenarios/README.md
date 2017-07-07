There are some sparrowfiles for installing [Archlinux](https://www.archlinux.org/).

## Usage

Download and boot into ISO - https://www.archlinux.org/download/

You may need extend main partiton:

    $ mount / -o remount,size=4G /run/archiso/cowspace

And start sshd

    $ systemctl start sshd

After that install [sparrow](https://github.com/melezhik/sparrow)

    $ pacman -Sy --noconfirm gcc make cpanminus && cpanm -n Sparrow

And finally you must setup password or public key for root user.

Main command:

    $ sparrowdo --host=<you_ip> --ssh_port=<your_port> --sparrowfile=install_arch_uefi_gpt.pl6 --bootstrap

## Files
install_arch_uefi_gtp.pl6 - For UEFI-GTP installation.
install_arch_bios_gtp.pl6 - For BIOS-GTP installation.
install_arch_uefi_gtp_raw.pl6 - For UEFI-GTP (without lvm) installation.

In `additional` directory lying examples for further provising.
