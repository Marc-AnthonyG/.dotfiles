export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

zstyle ':omz:update' mode reminder  

DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git asdf)

source $ZSH/oh-my-zsh.sh
export ARCHFLAGS="-arch x86_64"

alias termSource="~/.zshrc"
alias vim=nvim
alias canoeF="~/repository/canoe/frontend"
alias canoeB="~/repository/canoe/backend"
alias i3config="~/.dotfiles/i3/config"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
clear

# pnpm
export PNPM_HOME="/home/marc/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
