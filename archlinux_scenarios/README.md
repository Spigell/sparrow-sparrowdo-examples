There are some sparrowfiles for installing [Archlinux](https://www.archlinux.org/).

## Usage

Download and boot into ISO - https://www.archlinux.org/download/

You may need extend main partiton:
    $ mount / -o remount,size=4G /run/archiso/cowspace

And start sshd
    $ systemctl start sshd

After that install [sparrow](https://github.com/melezhik/sparrow)
    $ pacman -Sy --noconfirm gcc make cpanminus && cpanm -n Sparrow

Main command:
    $ sparrowdo --host=<you_ip> --ssh_port=<your_port> --sparrowfile=install_arch_uefi_gpt.pl6

## Files
install_arch_uefi_gtp.pl6 - For UEFI-GTP installation.

In `additional` directory lying examples for further provising.
