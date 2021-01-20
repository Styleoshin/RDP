#! /bin/bash

user="admin"
password="admin"
desktop_env="xfce4"
desktop_type="desktop-base"

while [ $# -gt 0 ] ; do
  case $1 in
    -u | --user) user="$2" ;;
    -p | --password) password="$2" ;;
    -e | --env) desktop_env="$2" ;;
    -t | --type) desktop_type="$2" ;;

  esac
  shift
done

sessionDesktopEnv()
{
    if [ $desktop_env eq "xfce4" ]; then
    return "/usr/bin/xfce4-session"
    elif [ $desktop_env eq "cinnamon-core" ]; then
    return "/usr/bin/cinnamon-session-cinnamon2d"
    fi    
}

echo "Installing RDP Be Patience... " >&2
{
sudo useradd -m $user
sudo adduser $user sudo
echo "${user}:${password}" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo apt-get update
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo DEBIAN_FRONTEND=noninteractive \
apt install --assume-yes $desktop_env $desktop_type
sudo bash -c 'echo "exec /etc/X11/Xsession $(sessionDesktopEnv)" > /etc/chrome-remote-desktop-session'  
sudo apt install --assume-yes xscreensaver
sudo systemctl disable lightdm.service
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
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