#!/bin/bash

echo "deb http://archive.raspberrypi.org/debian/ bookworm main" | sudo tee /etc/apt/sources.list.d/raspi.list

wget -O - https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/raspberrypi-archive-keyring.gpg
sudo apt update
sudo apt install raspi-gpio

