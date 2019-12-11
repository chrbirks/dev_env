#!/usr/bin/env bash

# 1. Iterate through config files in dev_env
#    .config/powerline/colorschemes/default.json
#    .config/powerline/themes/shell/default.json
#    .globalrc
#    .hgrc
#    .ignore
#    bash/.bashrc
#    emacs/emacs_packages/silicom-fw-common.el
#    spacemacs/.spacemacs
#    tmux/.tmux.conf
# 2. Diff with files on system
# 3. If they differ, ask if overwrite, skip or meld

# Reverse script for copying config back into dev_env
