#!/usr/bin/bash
echo "Xen Hypervisor 4.11 amd64 autoconfig & installer by https://github.com/independentcod";
echo "Please enter your password to continue...";
sudo apt update;
echo "Installing the necessary, please wait...";
sudo xterm -e apt install xen-hypervisor-4.11-amd64 xen-hypervisor-common xen-tools gparted xterm vinagre -y &
read -p "Do you want to launch the download of Windows-server-2019-evaluation.iso from Microsoft website? [ Y ]" dl
case $dl in
 Y) xterm -e wget -O windows-server-2019-evaluation.iso https://is.gd/winserver2019 &
esac
wget -O xen.cfg https://pastebin.com/raw/uDsnswQg;
if read -p "Give a name to your Virtual Machine: (eg: WindowsServer)" name; then
 sed -e "s|WindowsServer|server => \'${name}\',|g" xen.cfg
fi
echo "First you have to make sure you have space to make a new volume group";
sudo gparted;
echo "Now you must the this installer where the volume group will be installed";
if read -p "Where the volume group should be located? (eg. /dev/sda3)" loc; then
 sed -e "s|/dev/sda6|server => \'${loc}\',|g" xen.cfg && sudo vgcreate ${name} ${loc}
fi
if read -p "What size the logical volume should have? (Recommend: 20G minimum)" lv; then
 sudo vgcreate ${name} -L ${lv}
fi
if read -p "How much RAM, in MB, should your VM use? (Recommend: 2048)" maxmem; then
 sed -e "s|2048|server => \'${maxmem}\',|g" xen.cfg
fi
sudo brctl addbr xenbr0;
sudo ifconfig xenbr0 up;
read -p "Time to boot you machine are you ready? [ Y ]" ready
case $ready in
 Y) echo "To connect to the virtual machine the protocol is SPICE and address is 127.0.0.1:1" && sudo xl create xen.cfg && vinagre;
esac
