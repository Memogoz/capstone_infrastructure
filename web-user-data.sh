#!/bin/bash

apt update
apt install -y python3

# temporal
apt install -y apache2
systemctl enable apache2
systemctl start apache2
