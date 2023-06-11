export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

zstyle ':omz:update' mode reminder  

DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git asdf)

source $ZSH/oh-my-zsh.sh
export ARCHFLAGS="-arch x86_64"

. /opt/asdf-vm/asdf.sh

alias termSource="~/.zshrc"
alias vim=nvim

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
clear
