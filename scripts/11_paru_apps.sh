#!/usr/bin/env bash

paru -S mbpfan-git

sudo cp mbpfan.service /etc/systemd/system/
sudo systemctl enable mbpfan.service
sudo systemctl daemon-reload
sudo systemctl start mbpfan.service

paru neovim
paru firefox 
