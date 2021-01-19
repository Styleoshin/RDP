#! /bin/bash

user="admin"
password="admin123"
desktop_env="xfce4"
desktop_type="desktop-base"
distribution="google-chrome-stable_current_amd64.deb"

printf "Installing RDP Be Patience... " >&2
{
sudo useradd -m $user
sudo adduser  $user sudo
echo ' $user:$password' | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo apt-get update
wget "https://dl.google.com/linux/direct/${distribution}"
sudo dpkg --install $distribution
sudo apt install --assume-yes --fix-broken
sudo DEBIAN_FRONTEND=noninteractive \
apt install --assume-yes $desktop_env $desktop_type
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'  
sudo apt install --assume-yes xscreensaver
sudo systemctl disable lightdm.service
wget "https://dl.google.com/linux/direct/${distribution}"
sudo dpkg --install $distribution
sudo apt install --assume-yes --fix-broken
sudo apt install nautilus nano -y 
sudo adduser $user chrome-remote-desktop
} &> /dev/null &&
printf "\nSetup Complete " >&2 ||
printf "\nError Occured " >&2
printf '\nCheck https://remotedesktop.google.com/headless  Copy Command Of Debian Linux And Paste Down\n'
read -p "Paste Here: " CRP
su - $user -c """$CRP"""
printf 'Check https://remotedesktop.google.com/access/ \n\n'
if sudo apt-get upgrade &> /dev/null
then
    printf "\n\nUpgrade Completed " >&2
else
    printf "\n\nError Occured " >&2
fi
