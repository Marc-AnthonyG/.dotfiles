# ZSH 
## OMZ
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

source ~/.fzf.zsh

DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git asdf fzf-tab zsh-autosuggestions)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# KEYBINDINGS
bindkey -e 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# MAC
export ARCHFLAGS="-arch x86_64"

# ALIAS
alias aci-connect='eval "$(aws configure export-credentials --profile aci-dev --format env)" && yarn ba dev'
alias termSource="~/.zshrc"
alias vim=nvim
alias canoeF="~/repository/canoe/frontend"
alias canoeB="~/repository/canoe/backend"
alias i3config="~/.dotfiles/i3/config"
alias connectLinux="ssh marc@10.0.0.74"
alias gitDeleteMergeBranch="git branch --merged | grep -v \"^\*\\|main\" | xargs -n 1 git branch -d"

# ASDF
export PATH="$HOME/.asdf/shims:$PATH"
. ~/.asdf/plugins/golang/set-env.zsh
export PNPM_HOME="/Users/marc-anthonygirard/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# export
export ARCHFLAGS="-arch arm64"
export PATH="/Users/marc-anthonygirard/.local/bin:$PATH"
export PATH=$(asdf where lua)/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

#HISTORY
HISTSIZE=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
