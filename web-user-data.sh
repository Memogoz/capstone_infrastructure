#!/bin/bash

apt update
apt install -y python3

# temporal
apt install -y httpd
systemctl enable httpd
systemctl start http