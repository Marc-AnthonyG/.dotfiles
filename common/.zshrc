# ZSH
## OMZ
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git fzf-tab zsh-autosuggestions alias-tips)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Common alias
projects=(admin backend frontend devstack infra) # Need to have unique first letters

for p in $projects; do
    local char=$p[1]

    alias "x$char"="xtask $p"

    alias "x${char}s"="xtask $p -e stag"

    alias "x${char}p"="xtask $p -e prod"
done

alias x="xtask"
alias xs="xtask -e stag"
alias xp="xtask -e prod"

alias cx="cargo xtask"
alias cxp="cargo xtask -e prod"
alias cxs="cargo xtask -e stag"

alias bclii="cargo install --path ~/repository/burn-central/cli/crates/burn-central-cli --force"

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

# COMPLETION
tmux_ses_comp() {
    local cache_file="$HOME/.cache/git-repos-cache"
    local cache_age=3600  # 1 hour in seconds
    local -a repos
    local cache_mtime

    # Regenerate cache if needed
    if [[ ! -f "$cache_file" ]]; then
        mkdir -p "$(dirname "$cache_file")"
        find ~ -mindepth 1 -maxdepth 3 -type d -name '.git' -exec dirname {} \; 2>/dev/null > "$cache_file"
    else
        # Get cache file modification time (works on both macOS and Linux)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null)
        else
            cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null)
        fi

        # Regenerate if cache is older than cache_age
        if [[ -n "$cache_mtime" ]] && [[ $(($(date +%s) - cache_mtime)) -gt $cache_age ]]; then
            find ~ -mindepth 1 -maxdepth 3 -type d -name '.git' -exec dirname {} \; 2>/dev/null > "$cache_file"
        fi
    fi

    # Extract just the directory names (basenames) from full paths
    repos=(${(f)"$(cat "$cache_file" | xargs -n1 basename)"})

    _describe 'repository' repos
}

# Register the completion
compdef tmux_ses_comp tmux-ses

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

# Source platform-specific config
[[ -f ~/.extra.zsh ]] && source ~/.extra.zsh
