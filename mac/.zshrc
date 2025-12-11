# ZSH 
## OMZ
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

source ~/.fzf.zsh

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

# MAC
export ARCHFLAGS="-arch x86_64"

# ALIAS
alias aci-connect='eval "$(aws configure export-credentials --profile aci-dev --format env)" && yarn ba dev'
alias zshSource="source ~/.zshrc"
alias vim=nvim
alias connectLinux="ssh marc@10.0.0.74"
alias updateYabai='echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai'
alias cx="cargo xtask"
alias cxp="cargo xtask -e prod"
alias cxs="cargo xtask -e stag"
alias bclii="cargo install --path ~/repository/burn-central/cli/crates/burn-central-cli --force"

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
. ~/.asdf/plugins/golang/set-env.zsh
export PNPM_HOME="/Users/marc-anthonygirard/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# export
export ARCHFLAGS="-arch arm64"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="/Users/marc-anthonygirard/.local/bin:$PATH"
export PATH=$(asdf where lua)/bin:$PATH
export PATH="/Users/marc-anthonygirard/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
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
