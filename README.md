# DockerRestartScript

This is a simple script for people who have had problems with Docker container auto-restart after a reboot or an incorrect shutdown. In my case, the problem is with the [OpenVPN Access Server](https://openvpn.net) Docker container.
Specifically, these applications are run on Docker containers managed by [CasaOS](https://www.casaos.io).

## Problem Definition
After a restart caused by a power outage or other issues, all containers would function and start automatically except for the OpenVPN container.
Not finding an optimal solution, I decided to create a script that stops the failed auto-restart attempt of the container and starts a new, functioning one.

## Basic Info
The script waits for the operating system and Docker containers to load. Then it checks if the OpenVPN container is loaded correctly. If it is not, the script stops the current container and starts a new one.
The script is modifiable and adaptable to other containers that may have similar issues. Simply change the name of the container you want to monitor.

## Prepare the Script
Modify the script as follows:
- Change **CONTAINER_NAME** to the name of the container you want to monitor.
- 
## Start the Script at Boot
To start the script at system startup, a couple of steps are enough.

- Save the script to an appropriate location on your system, such as `/usr/local/bin/check_and_restart_container.sh`, and make it executable with the command sudo `chmod +x /usr/local/bin/check_and_restart_container.sh`
- Create a service file called mounter.service in /etc/systemd/system/: `sudo nano /etc/systemd/system/check_and_restart_container.service`
- Inside this file, insert the following content:

```ini
[Unit]
Description=Check and Restart Docker Container if Restarting
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/check_and_restart_container.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

- restart the deamon `sudo systemctl daemon-reload`
- enable the service to start during boot: `sudo systemctl enable /etc/systemd/system/check_and_restart_container.service`

Now, when the system starts, the script checks if the container is running properly.
