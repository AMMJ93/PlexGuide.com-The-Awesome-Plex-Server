![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)


# Install Radarr

![N](https://image.ibb.co/etHuY6/Snip20171029_13.png)

```sh
sudo apt update && sudo install libmono-cil-dev curl mediainfo
cd /opt
sudo wget $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
sudo tar -xvzf Radarr.develop.*.linux.tar.gz
```

# Creating a service for Radarr
```sh
sudo nano /etc/systemd/system/radarr.service
```

- Copy & Paste the info below into the ervice

```sh
[Unit]
Description=Radarr Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/mono /opt/Radarr/Radarr.exe --nobrowser &
TimeoutStopSec=20
KillMode=process 
Restart=always

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X to exit and save

## Start the Radarr Service
```sh
sudo systemctl daemon-reload
sudo systemctl enable radarr.service
sudo systemctl start radarr.service
sudo systemctl status radarr.service
```

- Press CTRL+C to exit status message
- To test, goto your http://ipv4address:7878

## Radarr Configuration
- Radarr - http://ipv4address:7878
- Settings: Click in the upper right
  - Advanced Settings: Turn on, far right, flip on and [Click] save
    - Media Management Tab
    - Rename Movies: Flip to yes
    - Analyse Video Files: Flip to no (if you forget, you will hit the 24hr Google Ban all the time)
    - [Click] save changes at the top right
  - Profiles Tab
    - Keep the (Any) profile, delete the rest. To delete, click the profiles and [Click] the delete button
  - [Click] Any (the settings below are recommended)
    - Cutoff WEBDL-720p
      - Qualities - Follow the order and have the ones listed below on; not listed... keep off (recommendation)
      - Note: You can turn on others, but keep it simple and keep the size simple
    - Remux-1080p
    - Bluray-1080p
    - Bluray-720p
    - WEBDL-1080p
    - HDTV-1080p
    - HDTV-720p
    - Bluray-576p
    - Bluray-480p
    - WEBDL-480p
    - DVD-R
    - DVD
    - WEBDL-480p
    - SDTV
    - [Click] save changes at top right
- Indexers Tab: You will need at least one provider.
  - SABNZBD:  Turn this one on
    - Name: SABNZBD
    - Host: Domain or IPV4 Address
    - Port: 8090
    - API Key: Goto SABNZBD - http://YOURIP-Domain:8090/sabnzbd/config/general/ and get the API KEY
    - Username: If you made a username in SAB, then put it here; otherwise leave blank
    - Password: If you made a password in SAB, then put it here; otherwise leave blank
    - Category: movies
    - Recent Priority: Hight
    - Older Priority: Normal or Low (if you love Movie downloads more than TV downloads; make normal)
    - [Click] Test - if having problems, check your IP, port, username and etc.  Trust me, it's you.
    - [Click] Save - if all is well
- General Tab:
  - Security:
  - Authentication: Forms (Login Page)
  - Username: remember it
  - Password: remember it
  - Automatic: On
  - [Click] save changes at top right
- Movies Icon: [Click] at the top
  - [Click] + Add Movies
  - [Click] Important Existing Series on Disk (can take awhile) (only applies if you have stuff on your G-Drive)
  - [Location] If existing on disk, should be /mnt/rclone-union/zilch/movies/
  - [Click] and then scroll down and click the [OK]
  - Let it load, can take awhile if you have many, if not; proceed
  - Once loaded, click the green check.  After this, your good in setting your movie location (where they currently are)
  - From here, explore and start finding your movies.
- http://ipv4address:7878 (for Radarr)
