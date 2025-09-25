# ZSH 
## OMZ
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git fzf-tab zsh-autosuggestions)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# KEYBINDINGS
bindkey -e 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

function gitDeleteMergeBranch() {
  remote_branches=$(git ls-remote --heads origin | awk '{print $2}' | sed 's/refs\/heads\///')
  git branch --format="%(refname:short)" | while read -r local_branch; do
    if ! echo "$remote_branches" | grep -q "^$local_branch$"; then
      git branch -D "$local_branch"
    fi
  done
}
alias gitDeleteMergeBranch=gitDeleteMergeBranch

# ASDF
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
. ~/.asdf/plugins/golang/set-env.zsh

# export
export PATH=$(asdf where lua)/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

source ~/.config/secrets.sh

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
