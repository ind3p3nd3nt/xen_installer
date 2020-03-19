#!/usr/bin/bash
echo "Xen Hypervisor 4.11 amd64 autoconfig & installer v1.1BETA by https://github.com/independentcod";
echo "Please enter your password to continue...";
sudo clear;
read -p "Do you want to install the xen dependencies and other software from apt? [ Y ]" ready;
case $ready in
Y) sudo xterm -e sudo apt update && sudo xterm -e sudo apt install xen-hypervisor-4.11-amd64 xen-hypervisor-common xen-tools gparted xterm vinagre -y &
esac
read -p "Do you want to launch the download of Windows-server-2019-evaluation.iso from Microsoft website? [ Y ]" dl;
case $dl in Y) xterm -e wget -O windows-server-2019-evaluation.iso https://is.gd/winserver2019 &
esac
read -p "Do you want to edit your configurations? [ Y ]" edit;
case $edit in Y) wget -O xen.cfg https://pastebin.com/raw/uDsnswQg;
esac
if read -p "Give a name to your Virtual Machine: [eg: WindowsServer]" name; 
then sed -i~ -e "s|WindowsServer|server => \'${name}\',|g" xen.cfg; 
read -p "Do you know in which partition you want to install your VM [ N ]" dl;
case $dl in N) echo "First you have to make sure you have enough space to make a new volume group" && sudo gparted;;
esac
echo "Now you must tell this installer where the volume group will be installed";
if read -p "Where the volume group should be located? (eg. /dev/sda3)" loc;
then sed -i~ -e "s|/dev/sda6|server => \'${loc}\',|g" xen.cfg && sudo vgcreate ${name} ${loc};
fi 
if read -p "What size the logical volume should have? (Recommend: 20G minimum)" lv;
then sudo lvcreate -L ${lv} ${name};
fi
if read -p "How much RAM, in MB, should your VM use? (Recommend: 2048)" maxmem;
then sed -i~ -e "s|2048|server => \'${maxmem}\',|g" xen.cfg;
fi
if read -p "Time to reboot your machine are you ready? (Make sure download is finished) [ Y ]" ready;
then case $ready in Y) echo "Once you are booted make sure you sre booting with xen and rerun this script for the second part of the setup. Rebooting in 15 seconds..." && sleep 15 && sudo reboot now;; esac
fi
if read -p "ARE YOU READY FOR THE 2ND PART OF THE SCRIPT? [ Y ]" ready;
then case $ready in Y) echo "To connect to the virtual machine the protocol is SPICE and address is 127.0.0.1:1" && sudo xl create xen.cfg && vinagre sudo brctl addbr xenbr0 && sudo ifconfig xenbr0 up;
fi
esac
