#!/bin/bash
#
# Title:      PGClone (A 100% PG Product)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/keys.sh
source /opt/plexguide/menu/functions/keyback.sh
source /opt/plexguide/menu/functions/pgclone.sh
################################################################################
question1 () {
  touch /opt/appdata/plexguide/rclone.conf
  account=$(cat /var/plexguide/project.account)
  project=$(cat /var/plexguide/pgclone.project)
  project=$(cat /var/plexguide/pgclone.transport)
  gstatus=$(cat /var/plexguide/gdrive.pgclone)
  tstatus=$(cat /var/plexguide/tdrive.pgclone)
  transportdisplay

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PGClone                     reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Data Transport Mode : [$transport]
2 - Google Account Login: [$account]
3 - Project Options     : [$project]
4 - Mount Management    : [good/bad]
5 - Key Management      : [keysdeployed]
Z - Exit
A - Deploy ~ $transport

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 Type Selection | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  transportmode
  question1
elif [ "$typed" == "2" ]; then
  gcloud auth login
  echo "NOT SET" > /var/plexguide/pgclone.project
  question1
elif [ "$typed" == "3" ]; then
  projectmenu
  question1
elif [ "$typed" == "4" ]; then
  mountsmenu
  question1
elif [ "$typed" == "5" ]; then
  question1
elif [[ "$typed" == "A" || "$typed" == "a" ]]; then
  inputphase
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  exit
else
  badinput
  keymenu; fi
#menu later
inputphase
}

inputphase () {
deploychecks

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Deployment               reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG is Deploying /w the Following Values:

CLIENT ID: $public

CLIENT SECRET: $secret

TEAMDRIVE: $teamdrive

EOF

read -p '🌍 Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then question1
else
  badinput
  inputphase
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Authentication    reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '🌍 Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/appdata/plexguide/pgclone.info

  accesstoken=$(cat /opt/appdata/plexguide/pgclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/appdata/plexguide/pgclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

# Reminder for gdrive/tdrive / check rclone to set if active, below just placeholder
variable /var/plexguide/project.account "NOT-SET"
variable /var/plexguide/pgclone.project "NOT-SET"
variable /var/plexguide/pgclone.teamdrive ""
variable /var/plexguide/pgclone.public ""
variable /var/plexguide/pgclone.secret ""
variable /var/plexguide/pgclone.transport "NOT-SET"
variable /var/plexguide/gdrive.pgclone "Not Active"
variable /var/plexguide/tdrive.pgclone "Not Active"

question1

#date=`date +%m%d`
#rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
#projectid="pg-$date-$rand"
#gcloud projects create $projectid
#sleep 1