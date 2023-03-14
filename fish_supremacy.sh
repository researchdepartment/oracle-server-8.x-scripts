#!/bin/bash
if [ "$(id -u)" != "0" ]; then
    SUDO="sudo"
else
    SUDO=""
fi

FISH_PATH_ESC=$(cat /etc/shells | grep fish | head -n1 | sed 's/\//\\\//g')

$SUDO sed -i "s/\/bin\/ash/$FISH_PATH_ESC/g" /etc/passwd
$SUDO sed -i "s/\/bin\/bash/$FISH_PATH_ESC/g" /etc/passwd
$SUDO sed -i "s/\/bin\/zsh/$FISH_PATH_ESC/g" /etc/passwd

su $USER
