#!/bin/bash

# Detect OS and set tmux prefix accordingly
if [ -f /etc/arch-release ]; then
    # Arch Linux - use Super/Windows+Space
    tmux set-option -g prefix M-Space
    tmux bind-key M-Space send-prefix
else
    # Other OS - use Ctrl+Space
    tmux set-option -g prefix C-Space
    tmux bind-key C-Space send-prefix
fi

tmux unbind-key C-b
