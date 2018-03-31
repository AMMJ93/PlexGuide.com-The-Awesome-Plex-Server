#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

HEIGHT=18
WIDTH=59
CHOICE_HEIGHT=16
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Settings"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Domain       : Set/Change a Domain"
         B "Notifications: Enable the Use of Notifications"
         C "Ports        : Turn On/Off Application Ports"
         D "Processor    : Enhance Processing Power"
         E "Kernel Mods  : Enhance Network Throughput"
         F "Redirect     : Force Apps to use HTTPS Only?"
         G "SuperSpeeds  : Change Gdrive Transfer Settings"
         H "WatchTower   : Auto-Update Application Manager"
         I "Import Media : Import Existing Media to GDrive "
         J "App Themes   : Install Dark Theme(s) For Apps "
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
################################################# START
if dialog --stdout --title "Domain Question" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nAre You Adding/Changing a Domain?" 7 34; then

  domain='yes'

  dialog --title "Input >> Your Domain" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Domain (Example - plexguide.com)" 8 40 2>/var/plexguide/server.domain
  dom=$(cat /var/plexguide/server.domain)

  dialog --title "Input >> Your E-Mail" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "E-Mail (Example - user@pg.com)" 8 40 2>/var/plexguide/server.email
  email=$(cat /var/plexguide/server.domain)

  dialog --infobox "Set Domain is $dom" 3 40
  sleep 2

  echo "Domain - Set to $dom" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

  dialog --infobox "Set E-Mail is $email" 3 40
  sleep 2

  echo "E-Mail - Set to $email" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
  clear

else
  domain="no"
  dialog --infobox "No Changes Were Made!" 3 38
  sleep 3
  bash /opt/plexguide/menus/settings/main.sh
  exit
fi
################################################## VAR CHANGE

rm -r /opt/appdata/plexguide/var.yml
ansible-playbook /opt/plexguide/ansible/config.yml --tags var
################################################## END

;;
    B)
          bash /opt/plexguide/menus/notifications/main.sh
          echo "Pushover Notifications are Working!" > /tmp/pushover
          ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
          ;;
    C)
        bash /opt/plexguide/menus/ports/main.sh ;;
    D)
        bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
    E)
        bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh ;;
    F)
        bash /opt/plexguide/menus/redirect/main.sh

        file="/var/plexguide/redirect.yes"
            if [ -e "$file" ]
                then
            sed -i 's/-OFF-/-ON-/g' /opt/plexguide/menus/redirect/main.sh
                else
            sed -i 's/-ON-/-OFF-/g' /opt/plexguide/menus/redirect/main.sh
        fi
        ;;
    G)
        bash /opt/plexguide/menus/transfer/main.sh ;;
    H)
        bash /opt/plexguide/menus/watchtower/main.sh ;;
    I)
        bash /opt/plexguide/menus/migrate/main.sh ;;
    J)
        bash /opt/plexguide/menus/themes/main.sh ;;
    Z)
        clear
        exit 0
        ;;
    esac
clear

bash /opt/plexguide/menus/settings/main.sh
exit 0
