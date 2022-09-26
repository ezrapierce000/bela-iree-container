#!/bin/bash

mkdir -p /root/.ssh
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
echo "export PROMPT_COMMAND='history -a' export HISTFILE=/root/.bash_history" >> /root/.bashrc
echo "PATH='/workspaces/bela-iree-container/bin:/root/miniconda3/bin:/opt/iree-host-build/bin:$PATH'" >> /root/.bashrc
source /home/scripts/docker-build/build_settings
